#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "sublime-text: install dependencies"
paruS ttf-ubuntu-font-family # Ubuntu Mono font
paruS hunspell-pl # polish dictionary
paruS hunspell-en_gb # english (United Kingdom) dictionary
paruS hunspell-en_us # english (United States) dictionary

print_step "sublime-text: copy preferences and snippets"
find User/ -mindepth 1 -print0 | while IFS= read -d '' -r path; do
	safe_copy "${path}" "${XDG_CONFIG_HOME:-$HOME/.config}/sublime-text/Packages/User/${path##*/}"
done

print_step "sublime-text: make it a default editor"
xdg-mime default sublime_text.desktop text/plain
