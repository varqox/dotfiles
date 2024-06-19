#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "networkmanager: install IWD"
paruS iwd

print_step "networkmanager: setup NetworkManager to use IWD"
sudo_safe_copy wifi_backend.conf '/etc/NetworkManager/conf.d/wifi_backend.conf'
sudo systemctl restart NetworkManager.service 

print_step "networkmanager: wait for the internet connection to be restored"
until ping -c 1 archlinux.org; do sleep 0.1; done
