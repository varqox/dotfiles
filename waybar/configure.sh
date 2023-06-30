#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "waybar: copy configs"
safe_copy --link config "${XDG_CONFIG_HOME:-$HOME/.config}/waybar/config"
safe_copy --link style.css "${XDG_CONFIG_HOME:-$HOME/.config}/waybar/style.css"

print_step "waybar: copy scripts"
safe_copy --link run-waybar.sh "${XDG_CONFIG_HOME:-$HOME/.config}/waybar/run-waybar.sh"
safe_copy --link go_to_sleep_warning.cc "${XDG_CONFIG_HOME:-$HOME/.config}/waybar/go_to_sleep_warning.cc"
safe_copy --link Makefile "${XDG_CONFIG_HOME:-$HOME/.config}/waybar/Makefile"

tmp_paruS gcc
print_step "waybar: compile scripts"
make -C "${XDG_CONFIG_HOME:-$HOME/.config}/waybar/"
