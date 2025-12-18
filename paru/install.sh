#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step 'paru: install'
paruS paru devtools # devtools is an optional dependency of paru for building and downloading inside chroot
print_step 'paru: regenerate development package database'
paru --gendb
