#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "mpv: autosub plugin: install subliminal"
paruS subliminal

function change_subliminal_path() {
	sed "s@^\(local subliminal = \).*@\1'/usr/bin/subliminal'@"
}

function disable_automatic_subtitle_download() {
	sed "s@^    auto = [^,]*,@    auto = false,@"
}

function disable_dutch_language() {
	sed "s@^  \(          { 'Dutch', 'nl', 'dut' },\)@--\1@"
}

function enable_polish_language() {
	sed "s@^--\(          { 'Polish', 'pl', 'pol' },\)@  \1@"
}

function change_shortcut_for_download_subs2() {
	sed "s@^\(mp.add_key_binding(\)'n'\(, 'download_subs2', download_subs2)\)@\1'B'\2@"
}

print_step "mpv: install plugin autosub"
safe_copy <(
		cat scripts/autosub/autosub.lua |
		change_subliminal_path |
		disable_automatic_subtitle_download |
		disable_dutch_language |
		enable_polish_language |
		change_shortcut_for_download_subs2
	) "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/scripts/autosub/autosub.lua"
safe_copy <(echo "require('autosub')") "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/scripts/autosub/main.lua"
