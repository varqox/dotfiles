#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "mpv: install plugin auto-save-state"
safe_copy --link scripts/auto-save-state.lua "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/scripts/auto-save-state.lua"
