#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step 'paru: install'
paruS paru
print_step 'paru: regenerate development package database'
paru --gendb
