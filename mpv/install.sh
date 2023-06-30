#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "mpv: install"
paruS mpv
