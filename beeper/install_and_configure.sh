#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

paruS beeper-v4-bin hunspell hunspell-en_us hunspell-en_gb hunspell-pl
tmp_paruS jq

print_step "beeper: ensuring beeper is not running"
kill_and_await_death beeper

print_step "beeper: fix dictionaries"
preferences_file="${XDG_CONFIG_HOME:-$HOME/.config}/BeeperTexts/Preferences"
if [[ ! -f "${preferences_file}" ]]; then
    printf '{}' > "${preferences_file}"
fi

edit_inplace "${preferences_file}" jq --compact-output '."spellcheck"."dictionaries" = ["en-US", "en-GB", "pl-PL"]'
