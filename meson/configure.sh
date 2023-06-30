#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "meson: copy configs"
safe_copy --link --recursive cross "${XDG_DATA_HOME:-$HOME/.local/share}/meson/cross"
