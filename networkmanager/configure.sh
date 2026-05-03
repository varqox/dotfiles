#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "networkmanager: configure region to PL"
sudo iw reg set PL
sudo_safe_copy /dev/stdin /etc/modprobe.d/wifi_region_PL.conf <<< 'options cfg80211 ieee80211_regdom=PL'
sudo mkinitcpio -P

print_step "networkmanager: install IWD"
paruS iwd

print_step "networkmanager: configure IWD"
sudo_safe_copy /dev/stdin /etc/iwd/main.conf << EOF
[General]
EnableNetworkConfiguration=false

[Rank]
BandModifier5Ghz=1.5

[Network]
EnableIPv6=true
EOF
sudo systemctl restart iwd.service

print_step "networkmanager: setup NetworkManager to use IWD"
sudo_safe_copy wifi_backend.conf '/etc/NetworkManager/conf.d/wifi_backend.conf'
sudo systemctl restart NetworkManager.service 

print_step "networkmanager: wait for the internet connection to be restored"
until ping -c 1 archlinux.org; do sleep 0.1; done
