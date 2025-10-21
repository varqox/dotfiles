#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

paruS tmux

print_step "tmux: copy config"
safe_copy --link tmux.conf "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
