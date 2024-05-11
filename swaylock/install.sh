#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "swaylock: install"
paruS swaylock
paruS ttf-ubuntu-font-family
