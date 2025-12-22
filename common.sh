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
        su root --login --command "pacman -S --noconfirm sudo && usermod --append --groups wheel '$USER' && echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel"
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
        # First clone or pull the repository
        TMP_PACKAGES+=(
            git
            devtools # optional runtime dependency of paru for building and downloading inside chroot
        )
        sudo pacman -S --noconfirm --asdeps --needed git devtools
        if [[ ! -d "${HOME}/.cache/paru/clone/paru/.git/" ]]; then
            mkdir -p "${HOME}/.cache/paru/clone/"
            git clone https://aur.archlinux.org/paru.git "${HOME}/.cache/paru/clone/paru/"
        else
            git -C "${HOME}/.cache/paru/clone/paru/" pull
        fi
        # Remove packages built previously
        rm -f "${HOME}/.cache/paru/clone/paru/"paru-*.pkg.*
        # Build packages
        makepkg --dir "${HOME}/.cache/paru/clone/paru/" --syncdeps --rmdeps --asdeps --needed --noconfirm
        # Remove paru-debug, as it is empty and unused
        rm -f "${HOME}/.cache/paru/clone/paru/"paru-debug-*.pkg.*
        # Install paru and update database
        sudo pacman -U --asdeps --needed --noconfirm "${HOME}/.cache/paru/clone/paru/"paru-*.pkg.*
        TMP_PACKAGES+=( paru )
        paru --gendb
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
        xargs --no-run-if-empty paru -S --noconfirm --needed
    # Mark specified packages as installed explicitly if they were previously installed as dependencies
    paru -D --asexplicit "$@"
}

function tmp_paruS {
    # Install packages as dependencies if they are not installed
    # Packages installed explicitly will still be marked as installed explicitly
    printf "%s\n" "$(filter_out_installed_packages "$@")" | \
        xargs --no-run-if-empty paru -S --noconfirm --asdeps --needed
    TMP_PACKAGES+=( "$@" )
}

function remove_tmp_packages() {
    # If TMP_PACKAGES is not empty
    if [[ -v TMP_PACKAGES ]] && [ "${#TMP_PACKAGES[@]}" -ne 0 ]; then
        # Filter packages to the unrequired ones only installed as dependecies (non-explicit)
        (paru -Q --unrequired --deps --quiet "${TMP_PACKAGES[@]}" || true) |
            # Remove only unrequired packages with their dependencies
            xargs --no-run-if-empty paru -R --noconfirm --recursive --nosave
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

# Usage: edit_inplace <file> <command> [args]...
function edit_inplace() {
    local file="$1"
    shift
    local new="$("$@" < "${file}")" || return
    printf "%s" "${new}" > "${file}"
}

# Usage kill_and_await_death <process_name_or_pid>...
function kill_and_await_death() {
    # After 2s send SIGKILL
    # Second timeout makes kill await the process death after the first kill (a nice hack)
    env kill --verbose --timeout 2000 KILL --timeout 1000 KILL "$@" || true
}
