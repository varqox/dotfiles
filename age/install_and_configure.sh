#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "age: install age and age-plugin-yubikey"
paruS age age-plugin-yubikey pcsclite yubikey-manager
sudo systemctl enable --now pcscd.socket
