#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

paruS beeper-v4-bin hunspell hunspell-en_us hunspell-en_gb hunspell-pl ttf-apple-emoji
tmp_paruS jq

print_step "beeper: ensuring beeper is not running"
kill_and_await_death beeper

print_step "beeper: configure"
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/BeeperTexts"
safe_copy --link custom.css "${XDG_CONFIG_HOME:-$HOME/.config}/BeeperTexts/custom.css"

print_step "beeper: fix dictionaries"
preferences_file="${XDG_CONFIG_HOME:-$HOME/.config}/BeeperTexts/Preferences"
if [[ ! -f "${preferences_file}" ]]; then
    printf '{}' > "${preferences_file}"
fi
edit_inplace "${preferences_file}" jq --compact-output '."spellcheck"."dictionaries" = ["en-US", "en-GB", "pl-PL"]'
