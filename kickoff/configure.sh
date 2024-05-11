#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "kickoff: copy config"
safe_copy --link config.toml "${XDG_CONFIG_HOME:-$HOME/.config}/kickoff/config.toml"
