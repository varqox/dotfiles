#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "sublime-merge: install dependencies"
paruS ttf-ubuntu-font-family # Ubuntu Mono font
paruS hunspell-pl # polish dictionary
paruS hunspell-en_gb # english (United Kingdom) dictionary
paruS hunspell-en_us # english (United States) dictionary

print_step "sublime-merge: copy preferences"
safe_copy --link --recursive User "${XDG_CONFIG_HOME:-$HOME/.config}/sublime-merge/Packages/User"
