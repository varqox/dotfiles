#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "wireplumber: install wireplumber"
paruS wireplumber

print_step "wireplumber: configure ignoring specific monitors"
mkdir -p "$HOME/.local/share/wireplumber/scripts/"
safe_copy 90-exclude-monitor-sink.lua "$HOME/.local/share/wireplumber/scripts/90-exclude-monitor-sink.lua"
mkdir -p "$HOME/.config/wireplumber/wireplumber.conf.d/"
safe_copy 90-exclude-monitor-sink.conf "$HOME/.config/wireplumber/wireplumber.conf.d/90-exclude-monitor-sink.conf"

print_step "wireplumber: make wireplumber pick up the changes"
systemctl --user restart wireplumber
