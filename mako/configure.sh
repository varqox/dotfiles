#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "mako: copy config"
safe_copy config "${XDG_CONFIG_HOME:-$HOME/.config}/mako/config"
