#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "keyd: install"
paruS keyd

print_step "keyd: check config before installing"
keyd check default.conf

print_step "keyd: install config"
sudo_safe_copy default.conf '/etc/keyd/default.conf'

print_step "keyd: enable keyd with the new config"
sudo systemctl enable keyd.service
sudo systemctl restart keyd.service

print_step "keyd: enable per-application shortcuts"
kill_and_await_death keyd-applicatio
sudo usermod --append --groups keyd "$(id -un)"
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/keyd"
safe_copy --link app.conf "${XDG_CONFIG_HOME:-$HOME/.config}/keyd/app.conf"
keyd-application-mapper --daemonize
