#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "mpv: autosubsync: install dependencies"
paruS ffmpeg
paruS alass
paruS python-ffsubsync

print_step "mpv: install plugin autosubsync"
find scripts/autosubsync/ -mindepth 1 -print0 | while IFS= read -d '' -r path; do
	safe_copy "${path}" "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/scripts/autosubsync/${path##*/}"
done
safe_copy script-opts/autosubsync.conf "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/script-opts/autosubsync.conf"
