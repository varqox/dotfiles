#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "audacious: copy config"
safe_copy <(sed "s/@user@/${USER}/g" config) "${XDG_CONFIG_HOME:-$HOME/.config}/audacious/config"
