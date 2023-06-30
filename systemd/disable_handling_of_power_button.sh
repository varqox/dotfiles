#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "systemd: disable handling of the power button"
sudo_safe_copy disable_handling_of_power_button.conf /etc/systemd/logind.conf.d/disable_handling_of_power_button.conf
