#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "alacritty: install"
paruS alacritty
paruS ttf-hack # font
