#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "scripts: install connect-to-wifi.sh"
paruS iwd fzf
safe_copy --link connect-to-wifi.sh "$HOME/.local/bin/connect-to-wifi.sh"

print_step "scripts: install connect-bluetooth.sh"
paruS bluez-utils fzf
safe_copy --link connect-bluetooth.sh "$HOME/.local/bin/connect-bluetooth.sh"
