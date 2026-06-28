#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "swaylock: copy config"
safe_copy config "${XDG_CONFIG_HOME:-$HOME/.config}/swaylock/config"
