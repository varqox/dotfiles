#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

paruS ticktick

print_step "ticktick: enable wayland support"
safe_copy --link user-flags.conf "${XDG_CONFIG_HOME:-$HOME/.config}/ticktick/user-flags.conf"
