#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "age: install age and age-plugin-yubikey"
paruS age age-plugin-yubikey pcsclite
sudo systemctl enable --now pcscd.socket

print_step "age: setup age-yubikey-identity.txt"
identity=$(age-plugin-yubikey --identity 2> /dev/null)
if [ ! -z "${identity}" ]; then
	safe_copy <(echo "${identity}") "${XDG_CONFIG_HOME:-$HOME/.config}/.age-yubikey-identity.txt"
else
	warn "Installing ${XDG_CONFIG_HOME:-$HOME/.config}/.age-yubikey-identity.txt skipped due to a missing YubiKey setup for age. To set up the YubiKey run: age-plugin-yubikey"
fi
