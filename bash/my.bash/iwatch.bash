#!/usr/bin/bash

# Usage: iwatch <PATH...> [-- [COMMAND...]]
# E.g. iwatch . -- echo @
# E.g. iwatch src -- cargo run
function iwatch() (
    set -uo pipefail

    if (($# == 0)); then
        echo "Usage: ${FUNCNAME[0]} <PATH...> [-- <COMMAND> [ARGS...]]" >&2
        echo "E.g. ${FUNCNAME[0]} . -- echo @" >&2
        echo "E.g. ${FUNCNAME[0]} src -- cargo run" >&2
        return 1
    fi

    files=()
    while (($# > 0)); do
        if [[ "$1" == '--' ]]; then
            shift
            break
        fi
        files+=("$1")
        shift
    done
    if (($# == 0)); then
        if [[ -t 1 ]]; then
            set -- printf "%s\n" @
        else
            set -- printf "%s\0" @
        fi
    fi
    # Generate random token to replace args == @ with it, because xargs substitutes @ even if
    # it is a substring, but we want equality, not substring...
    token="${RANDOM}"
    declare -i found=1
    while ((found)); do
        found=0
        for arg in "$@"; do
            if [[ "${arg}" == *"${token}"* ]]; then
                found=1
                break
            fi
        done
    done
    # Replace @ with token
    args=()
    for arg in "$@"; do
        if [[ "${arg}" == @ ]]; then
            args+=("${token}")
        else
            args+=("${arg}")
        fi
    done
    # Watch the files
    inotifywait --monitor --recursive --event close_write,delete,moved_to,create --format "%w%f%0" --no-newline -- "${files[@]}" |
        if IFS= read -d '' -r p; then
            while true; do
                # Remove duplicates for up to 50 ms
                for ((i=0; i < 5; ++i)); do
                    if IFS= read -d '' -r -t 0.01 pn; then
                        if [[ "${pn}" != "${p}" ]]; then
                            break
                        fi
                    else
                        pn="${p}"
                        break
                    fi
                done
                printf "%s\0" "${p}"
                if [[ "${pn}" == "${p}" ]]; then
                    read -d '' -r p || break
                else
                    p="${pn}"
                fi
            done
        fi |
            xargs --null -I "${token}" -- "${args[@]}"
)

# Execute function unless sourced
return 0 2> /dev/null || iwatch "$@"
