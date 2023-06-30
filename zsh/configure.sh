#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "zsh: install oh-my-zsh-git"
paruS oh-my-zsh-git

print_step "zsh: install used utilities"
paruS neovim ccache clang gcc exo procps-ng gdb git meson ffmpeg speedtest-cli fzf bat

print_step "zsh: copy configs"
safe_copy --link zshrc "$HOME/.zshrc"

print_step "zsh: create ~/.cache directory for oh-my-zsh"
mkdir -p "$HOME/.cache"

print_step "zsh: change shell to zsh"
[ "$SHELL" = "/usr/bin/zsh" ] || sudo chsh -s /usr/bin/zsh "${USER}"
