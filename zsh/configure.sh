#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "zsh: install used utilities"
paruS neovim ccache clang gcc exo procps-ng gdb git meson ffmpeg speedtest-cli fzf bat

print_step "zsh: copy configs"
safe_copy --link zshrc "$HOME/.zshrc"
safe_copy --link zshenv "$HOME/.zshenv"
safe_copy --link p10k.zsh "$HOME/.p10k.zsh"
safe_copy --link zshrc.local "$HOME/.zshrc.local"

print_step "zsh: change shell to zsh"
[ "$SHELL" = "/usr/bin/zsh" ] || sudo chsh -s /usr/bin/zsh "${USER}"
