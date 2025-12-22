#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

paruS ticktick hunspell hunspell-en_us hunspell-en_gb hunspell-pl
tmp_paruS jq

print_step "ticktick: ensuring ticktick is not running"
kill_and_await_death ticktick

print_step "ticktick: enable wayland support"
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/ticktick"
safe_copy --link user-flags.conf "${XDG_CONFIG_HOME:-$HOME/.config}/ticktick/user-flags.conf"

print_step "ticktick: fix dictionaries"
preferences_file="${XDG_CONFIG_HOME:-$HOME/.config}/ticktick/Preferences"
if [[ ! -f "${preferences_file}" ]]; then
    printf '{}' > "${preferences_file}"
fi

edit_inplace "${preferences_file}" jq --compact-output '."spellcheck"."dictionaries" = ["en-US", "en-GB", "pl-PL"]'
