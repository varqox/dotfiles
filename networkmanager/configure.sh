#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "networkmanager: install IWD"
paruS iwd

print_step "networkmanager: setup NetworkManager to use IWD"
sudo_safe_copy wifi_backend.conf '/etc/NetworkManager/conf.d/wifi_backend.conf'
