#!/usr/bin/bash

function ppid() (
    set -uo pipefail
    grep '^PPid:' < "/proc/${1-$$}/status" | cut -f 2
)

# Execute function unless sourced
return 0 2> /dev/null || ppid "$@"
