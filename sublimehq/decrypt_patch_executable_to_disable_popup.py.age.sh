#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

if [ ! "$#" = 1 ]; then
	echo "Usage: $0 <output file>"
	exit 1
fi
output_file="$1"

print_step "sublimehq: decrypt patch_executable_to_disable_popup.py.age"
tmp_paruS age age-plugin-yubikey pcsclite
sudo systemctl start pcscd.socket

age --decrypt --identity "${XDG_CONFIG_HOME:-$HOME/.config}/age-yubikey-identity.txt" -o "${output_file}" patch_executable_to_disable_popup.py.age
# To encrypt use:
# age --encrypt --identity ~/.config/age-yubikey-identity.txt -o patch_executable_to_disable_popup.py.age patch_executable_to_disable_popup.py
