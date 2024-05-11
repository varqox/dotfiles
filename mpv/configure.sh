#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "mpv: copy configs"
safe_copy --link mpv.conf "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/mpv.conf"
safe_copy --link input.conf "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/input.conf"
