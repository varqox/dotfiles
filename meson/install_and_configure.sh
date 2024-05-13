#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "meson: install meson and cross files' dependencies"
paruS meson
paruS clang
paruS llvm # for llvm-symbolizer, so that sanitizers print file:line_number instead of bare address
paruS mold
paruS sccache
paruS pkgconf # for pkg-config in cross files
paruS binutils # for strip in cross files

print_step "meson: copy configs"
safe_copy --link --recursive cross "${XDG_DATA_HOME:-$HOME/.local/share}/meson/cross"
