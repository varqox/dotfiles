#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "systemd: disable handling of the power button"
sudo_safe_copy /dev/stdin /etc/systemd/logind.conf.d/disable_handling_of_power_button.conf << EOF
[Login]
HandlePowerKey=ignore
EOF
sudo systemctl reload systemd-logind
