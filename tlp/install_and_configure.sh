#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "tlp: install"
paruS tlp

print_step "tlp: configure"
sudo_safe_copy "$(cpu_vendor)".conf "/etc/tlp.d/10-my.conf"

print_step "tlp: enable and restart"
sudo systemctl enable tlp.service
sudo systemctl restart tlp.service
