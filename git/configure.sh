#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

paruS neovim diffr

print_step "git: copy config"
safe_copy --link gitconfig "$HOME/.gitconfig"
