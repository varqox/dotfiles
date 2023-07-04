#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "mpv: autosub plugin: install subliminal"
paruS subliminal

print_step "mpv autosub plugin: decrypt opensubtitles_credentials.age"
tmp_paruS age age-plugin-yubikey pcsclite
sudo systemctl start pcscd.socket

opensubtitles_credentials="--          { '--opensubtitles', 'USERNAME', 'PASSWORD' },"
if [ ! -z "$(age-plugin-yubikey --list)" ] && [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/age-yubikey-identity.txt" ]; then
	opensubtitles_credentials=$(age --decrypt --identity "${XDG_CONFIG_HOME:-$HOME/.config}/age-yubikey-identity.txt" opensubtitles_credentials.age)
else
	warn "Decrypting of opensubtitles_credentials.age skipped due to a missing YubiKey and age setup"
fi

function change_subliminal_path() {
	sed "s@^\(local subliminal = \).*@\1'/usr/bin/subliminal'@"
}

function enable_searching_opensubtitles() {
	sed "s@^--          { '--opensubtitles', 'USERNAME', 'PASSWORD' },@  ${opensubtitles_credentials}@"
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
		disable_dutch_language |
		enable_polish_language |
		enable_searching_opensubtitles |
		change_shortcut_for_download_subs2
	) "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/scripts/autosub/autosub.lua"
safe_copy <(echo "require('autosub')") "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/scripts/autosub/main.lua"
