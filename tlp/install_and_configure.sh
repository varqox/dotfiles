#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "tlp: install"
paruS tlp

print_step "tlp: configure"
sudo_safe_copy my.conf "/etc/tlp.d/10-my.conf"

print_step "tlp: enable and restart"
sudo systemctl enable tlp.service
sudo systemctl restart tlp.service
