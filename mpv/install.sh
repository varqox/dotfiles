#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "mpv: install"
paruS mpv
