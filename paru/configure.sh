#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "paru: copy config"
safe_copy --link paru.conf "${XDG_CONFIG_HOME:-$HOME/.config}/paru/paru.conf"
