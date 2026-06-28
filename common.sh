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

function decide_interactively() {
    local i
    local what
    while true; do
        echo -E $'\x1b[0;1mWhat to do?\x1b[0m' > /dev/tty
        for i in "$@"; do
            echo $'\x1b[0;1m  '"${i%%:*}"$'\x1b[0m: '"${i#*:}" > /dev/tty
        done
        IFS= read -r -p "> " what || return
        for i in "$@"; do
            if [[ "${what}" == "${i%%:*}" ]]; then
                echo -E "${what}"
                return
            fi
        done
        echo -E $'\x1b[0;1;31mUnrecognised choice: \x1b[0m'"${what}" > /dev/tty
    done
}

function safe_copy_impl() (
    local wrapper_cmd="${1?:missing wrapper_cmd}"
    local src="${2:?missing src path}"
    local dest="${3:?missing dest path}"
    if (($# != 3)); then
        echo -E $'\x1b[0;1;33m'"Invalid number of arguments: got $(($# - 1)), expected 2"$'\x1b[0m' > /dev/tty
    fi

    # To support piping:
    local real_src
    local tmp_file=''
    if [[ "${src}" == '-' ]]; then
        src='/dev/stdin'
    fi
    if [[ "${src}" == "/dev/stdin" ]] || [[ "${src}" == /dev/*/fd/* ]] || [[ -p "${src}" ]]; then
        trap 'rm -f "${tmp_file}"' EXIT
        tmp_file="$(mktemp)"
        cat < "${src}" > "${tmp_file}"
        real_src="${tmp_file}"
    else
        real_src="${src}"
    fi

    while true; do
        if [[ ! -e "${dest}" ]]; then
            if [[ "${dest}" == */* ]]; then
                until "${wrapper_cmd}" mkdir -p "${dest%/*}"; do
                    echo -E $'\x1b[0;1;33m'"Failed to create directory ${dest%/*}"$'\x1b[0m' > /dev/tty
                    case "$(decide_interactively "a:abort" "r:retry" "s:skip")" in
                        a) return 1;;
                        s) return 0;;
                        r) continue;;
                    esac
                    return 1
                done
            fi
            until "${wrapper_cmd}" cp --preserve=mode --update=none-fail --dereference --no-target-directory "${real_src}" "${dest}"; do
                echo -E $'\x1b[0;1;33m' "Failed to copy ${src} to ${dest}"$'\x1b[0m' > /dev/tty
                case "$(decide_interactively "a:abort" "r:retry" "s:skip")" in
                    a) return 1;;
                    s) return 0;;
                    r) continue;;
                esac
                return 1
            done
            return
        fi
        if [[ ! -f "${dest}" ]]; then
            echo -E $'\x1b[0;1;33mFile '"${dest}"' exists and is not a regular file...\x1b[0m' > /dev/tty
            case "$(decide_interactively "a:abort" "r:retry (check again)" "s:skip")" in
                a) return 1;;
                s) return 0;;
                r) continue;;
            esac
            return 1
        fi
        until "${wrapper_cmd}" diff --unified --minimal --expand-tabs --tabsize=4 --show-c-function --color=always "${dest}" "${real_src}"; do
            echo -E $'\x1b[0;1;33mOverwriting file '"${dest} with ${src} would introduce the above changes."$'\x1b[0m' > /dev/tty
            case "$(decide_interactively "a:abort" "o:overwrite" "r:retry (check again)" "s:skip")" in
                a) return 1;;
                o) break;;
                r) continue;;
                s) return 0;;
            esac
            return 1
        done
        # Copy the file. --remove-destination ensures we don't override other paths hard-linked to the dest file.
        until "${wrapper_cmd}" cp --preserve=mode --remove-destination --dereference --no-target-directory "${real_src}" "${dest}"; do
            echo -E $'\x1b[0;1;33m'"Failed to copy ${src} to ${dest}"$'\x1b[0m' > /dev/tty
            case "$(decide_interactively "a:abort" "r:retry" "s:skip")" in
                a) return 1;;
                r) continue;;
                s) return 0;;
            esac
            return 1
        done
        return
    done
)

function safe_copy() {
    safe_copy_impl "env" "$@"
}

function sudo_safe_copy() {
    safe_copy_impl "sudo" "$@"
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
