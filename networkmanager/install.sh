#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "networkmanager: install NetworkManager"
paruS networkmanager

print_step "networkmanager: enable and restart NetworkManager"
sudo systemctl enable NetworkManager.service
sudo systemctl restart NetworkManager.service

print_step "networkmanager: wait for the internet connection to be restored"
until ping -c 1 archlinux.org; do sleep 0.1; done
