#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "scripts: install connect-to-wifi.sh"
paruS iwd fzf
safe_copy --link connect-to-wifi.sh "$HOME/.local/bin/connect-to-wifi.sh"

print_step "scripts: install connect-bluetooth.sh"
paruS bluez-utils fzf
safe_copy --link connect-bluetooth.sh "$HOME/.local/bin/connect-bluetooth.sh"

print_step "scripts: install translate-subs"
paruS python-selenium
safe_copy --link translate-subs "$HOME/.local/bin/translate-subs"

print_step "scripts: install backup"
safe_copy --link backup "$HOME/.local/bin/backup"
