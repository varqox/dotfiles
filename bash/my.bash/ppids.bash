#!/usr/bin/bash

function ppids() (
    set -uo pipefail

    local pid
    local status
    local name
    pid="${1-$$}"
    while ((pid != 0)); do
        status="$(cat "/proc/${pid}/status")" || return
        name="$(grep '^Name:' <<< "${status}" | cut -f 2)" || return
        echo "${pid}: ${name}"
        pid="$(grep '^PPid:' <<< "${status}" | cut -f 2)" || return
    done | tac
)

# Execute function unless sourced
return 0 2> /dev/null || ppids "$@"
