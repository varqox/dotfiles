#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

paruS zed

print_step "zed: copy settings.json"
safe_copy --link settings.json "${XDG_CONFIG_HOME:-$HOME/.config}/zed/settings.json"

print_step "zed: copy keymap.json"
safe_copy --link keymap.json "${XDG_CONFIG_HOME:-$HOME/.config}/zed/keymap.json"
