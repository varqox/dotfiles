#!/bin/bash
set -euo pipefail

# Change working directory to the directory containing the currently run script
cd -P "$(dirname -- "$0")"

tmp_dir=$(mktemp -d)
# Kill all background jobs and clean
trap 'kill $(jobs -p) 2> /dev/null || true; remove_tmp_packages; rm -rf ${tmp_dir}' EXIT

function sudo() {
    if [ ! -x /usr/bin/sudo ]; then
        printf 'Enter the root '
        su root --login --command "pacman --noconfirm -S sudo && usermod --append --groups wheel '$USER' && echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel"
    fi
    if [[ -v COMMON_SUDO_SPAWNED ]]; then
        # Sudo loop so that sudo won't timeout
        /usr/bin/sudo -v # If sudo asks for password it will ask now and not fail in the loop below
        (while :; do /usr/bin/sudo -v; sleep 59; done)&
        COMMON_SUDO_SPAWNED=true
    fi
    /usr/bin/sudo "$@"
}

function safe_copy() {
    local link= # links instead of copy, but fallbacks to copy
    if [ "$1" = "--link" ]; then
        link="--link"
        shift 1
    fi

    if [ "$1" = "--recursive" ]; then
        shift 1
        local other_args=("${@:1:${#@}-2}") # all args preceding the last two
        local src="${@: -2:1}"; src="${src%/}" # the penultimate argument
        local dest="${@: -1}"; dest="${dest%/}" # the last argument
        # type l to support usage: safe_copy --recursive <(...) dest
        find "${src}" -type f,l -print0 | while read -d '' x; do
            safe_copy ${link} "${other_args[@]}" "${x}" "${dest}${x#$src}" # works for both src == x (src is not a directory) and src being a directory
        done
        return
    fi

    function is_safe_to_copy() {
        local src="$1"
        local dest="$2"
        if [ ! -e "${dest}" ]; then
            return 0
        fi
        if diff --brief "${src}" "${dest}" > /dev/null; then
            return 0
        fi
        function is_file_tracked() {
            git ls-files --error-unmatch -- "$1" > /dev/null 2> /dev/null
        }
        # Check if any previous revision of ${src} equals ${dest}
        if is_file_tracked "${src}"; then
            local rev
            for rev in $(git log --format=format:%H -- "${src}"); do
                if diff --brief <(git show "$rev:./${src}") "${dest}" > /dev/null; then
                    return 0
                fi
            done
        fi
        return 1
    }

    local src="$1"
    local dest="$2"
    # To support usages:
    # - safe_copy <(...) dest
    # - safe_copy /dev/stdin dest <<< "abc"
    if [[ "${src}" == /dev/fd/* ]] || [[ "${src}" == /proc/self/fd/* ]] || [ -L "${src}" ]; then
        cat < "${src}" > "$tmp_dir/src"
        src="$tmp_dir/src"
    fi

    if ! is_safe_to_copy "${src}" "${dest}"; then
        echo "Installing ${src} would overwrite unexpected changes in ${dest}:"
        diff "${dest}" "${src}"
        return 1
    fi

    mkdir --parents $(dirname -- "${dest}")
    # cp --link does not fail if ${src} and ${dest} are the same file (their inodes are equal) and
    # cp --link --force replaces the destination with the hard link if the destination file exists
    ([[ ! -v link ]] && cp --no-target-directory --link --force "${src}" "${dest}" 2> /dev/null) ||
    cp --no-target-directory --remove-destination "${src}" "${dest}"
}

function sudo_safe_copy() {
    local i
    for i in "$@"; do
        if [ "${i}" == "--link" ]; then
            /bin/echo -e "\033[1;31mBUG: sudo_safe_copy with --link is disallowed for safety reasons: it is unsafe to have the file owned by root being editable by a non-root user\033[m"
            exit 1
        fi
    done
    sudo bash -c "$(declare -f safe_copy); safe_copy \"\$@\"" "$0" "$@"
}

function print_step() {
    /bin/echo -e "\033[1;32m==>\033[0;1m $1\033[m"
}

function warn() {
    /bin/echo -e "\033[0;33m$1\033[m"
}

function error() {
    /bin/echo -e "\033[0;31m$1\033[m"
    exit 1
}

function install_paru_if_absent {
    if ! command -v paru > /dev/null; then
        print_step 'Installing paru'
        # First check for the cached version of the built paru package
        if [ -f "/var/cache/pacman/pkg/paru.pkg.tar.zst" ]; then
            sudo pacman --noconfirm -U --asdeps "/var/cache/pacman/pkg/paru.pkg.tar.zst"
            paru --noconfirm -S --needed --asdeps paru # upgrade paru if necessary
        else
            sudo pacman --noconfirm -S --needed --asdeps git rust
            TMP_PACKAGES+=( git rust )
            git clone https://aur.archlinux.org/paru.git "${tmp_dir}/paru"
            (cd "${tmp_dir}/paru" && makepkg --syncdeps --install --asdeps --noconfirm && cp paru-*.zst /var/cache/pacman/pkg/paru.pkg.tar.zst)
        fi
        paru --gendb
        TMP_PACKAGES+=( paru )
    fi
}

function filter_out_installed_packages {
    printf '%s\n' "$@" | \
        grep --invert-match --line-regexp --fixed-strings --file=<(paru -Q --quiet "$@" 2> /dev/null) || true
}

function paruS {
    install_paru_if_absent
    # Filter arguments to only uninstalled packages (it is faster in case all packages are already installed)
    printf "%s\n" "$(filter_out_installed_packages "$@")" | \
        xargs --no-run-if-empty paru --noconfirm -S --needed
    # Mark specified packages as installed explicitly if they were previously installed as dependencies
    paru -D --asexplicit "$@"
}

function tmp_paruS {
    # Install packages as dependencies if they are not installed
    # Packages installed explicitly will still be marked as installed explicitly
    printf "%s\n" "$(filter_out_installed_packages "$@")" | \
        xargs --no-run-if-empty paru --noconfirm -S --needed --asdeps
    TMP_PACKAGES+=( "$@" )
}

function remove_tmp_packages() {
    # If TMP_PACKAGES is not empty
    if [[ -v TMP_PACKAGES ]] && [ "${#TMP_PACKAGES[@]}" -ne 0 ]; then
        # Filter packages to ones only installed as dependecies (non-explicit)
        (paru -Q --deps --quiet "${TMP_PACKAGES[@]}" || true) |
            # Remove only unrequired packages with their dependencies
            xargs --no-run-if-empty paru --noconfirm -R --recursive --nosave --unneeded
    fi
}

# Returns either "amd" or "intel"
function cpu_vendor() {
    tmp_paruS libcpuid
    vendor_str=$(cpuid_tool --vendorstr | tail -n 1)
    case "$vendor_str" in
        "AuthenticAMD") echo amd ;;
        "GenuineIntel") echo intel ;;
        *) error "Unsupported CPU with cpuid: ${vendor_str}" ;;
    esac
}
