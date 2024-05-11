#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "mpv: autosubsync: install dependencies"
paruS ffmpeg
paruS alass

print_step "mpv: install plugin autosubsync"
safe_copy --link --recursive scripts/autosubsync "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/scripts/autosubsync"
safe_copy --link script-opts/autosubsync.conf "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/script-opts/autosubsync.conf"
