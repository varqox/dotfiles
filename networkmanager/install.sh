#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "networkmanager: install NetworkManager"
paruS networkmanager

print_step "networkmanager: enable and restart NetworkManager"
sudo systemctl enable NetworkManager.service
sudo systemctl restart NetworkManager.service
