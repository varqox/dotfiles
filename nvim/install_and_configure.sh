#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

paruS neovim

print_step "nvim: copy config"
safe_copy --link init.vim "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.vim"
