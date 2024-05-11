#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "age: install age and age-plugin-yubikey"
paruS age age-plugin-yubikey pcsclite
sudo systemctl enable --now pcscd.socket
