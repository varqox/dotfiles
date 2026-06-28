#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "alacritty: copy config"
safe_copy alacritty.toml "${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/alacritty.toml"
