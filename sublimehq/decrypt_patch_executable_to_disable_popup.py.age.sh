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

identities=$(age-plugin-yubikey --identity 2>&1)
if [ -z "$identities" ]; then
	warn "Found no inserted YubiKey. Cannot decrypt."
	exit 1
fi

for identity_name in $(grep -P '^#\s*Name: ' <<< "$identities" | sed 's/.*identity //'); do
	echo "Trying to decrypt ${identity_name} (please touch the YubiKey)"
	age --decrypt --identity <(age-plugin-yubikey --identity 2> /dev/null) --output="${output_file}" "patch_executable_to_disable_popup.py.${identity_name}.age" && exit 0
done

# To generate key-pair on the inserted YubiKey use:
# age-plugin-yubikey
# To encrypt use:
# age --encrypt --identity <(age-plugin-yubikey --identity 2> /dev/null) --output="patch_executable_to_disable_popup.py.$(age-plugin-yubikey --identity |& grep -P '^#\s*Name: ' | sed 's/.*identity //').age" patch_executable_to_disable_popup.py
