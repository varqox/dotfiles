#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "alacritty: copy config"
safe_copy --link alacritty.yml "${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/alacritty.yml"
