#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "dns: configure systemd-resolved"
sudo mkdir -p "/etc/systemd/resolved.conf.d/"
sudo_safe_copy my.conf "/etc/systemd/resolved.conf.d/my.conf"

print_step "dns: enable systemd-resolved"
sudo systemctl enable systemd-resolved.service
sudo systemctl restart systemd-resolved.service

print_step "dns: migrate clients using /etc/resolv.conf to systemd-resolved"
sudo ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
