#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

paruS diffr

print_step "git: copy config"
safe_copy gitconfig "$HOME/.gitconfig"
