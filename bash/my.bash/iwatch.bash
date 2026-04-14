#!/usr/bin/bash

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
        set -- printf "%s\0" @
    fi

    inotifywait --monitor --recursive --event close_write,delete,moved_to,create --format "%w%f%0" --no-newline -- "${files[@]}" |
        if IFS= read -d '' -r p; then
            while true; do
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
            xargs --null -I @ -- "$@"
)

# Execute function unless sourced
return 0 2> /dev/null || iwatch "$@"
