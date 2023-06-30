#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "mako: copy config"
safe_copy --link config "${XDG_CONFIG_HOME:-$HOME/.config}/mako/config"
