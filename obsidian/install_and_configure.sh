#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

paruS obsidian hunspell hunspell-en_us hunspell-en_gb hunspell-pl
tmp_paruS jq

print_step "obsidian: ensuring obsidian is not running"
{ pgrep --full /obsidian/app.asar || true; } | while IFS= read -r pid; do kill_and_await_death "${pid}"; done

print_step "obsidian: fix dictionaries"
preferences_file="${XDG_CONFIG_HOME:-$HOME/.config}/obsidian/Preferences"
if [[ ! -f "${preferences_file}" ]]; then
    printf '{}' > "${preferences_file}"
fi

edit_inplace "${preferences_file}" jq --compact-output '."spellcheck"."dictionaries" = ["en-US", "en-GB", "pl-PL"]'
