#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "systemd: disable buggy handling of suspend on lid close"
sudo_safe_copy disable_handling_of_suspend_on_lid_close.conf /etc/systemd/logind.conf.d/disable_handling_of_suspend_on_lid_close.conf
