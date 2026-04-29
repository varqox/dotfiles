#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "systemd: disable buggy handling lid events when power source / dock are connected"
sudo_safe_copy /dev/stdin /etc/systemd/logind.conf.d/disable_handling_lid_events_when_plugged_or_docked.conf << EOF
[Login]
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
# React to lid events immediately
HoldoffTimeoutSec=0s
EOF
sudo systemctl reload systemd-logind
