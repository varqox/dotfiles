#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "scripts: install connect-to-wifi.sh"
paruS networkmanager fzf
safe_copy connect-to-wifi.sh "$HOME/.local/bin/connect-to-wifi.sh"

print_step "scripts: install share-wifi.sh"
paruS networkmanager iwd fzf qrencode
safe_copy share-wifi.sh "$HOME/.local/bin/share-wifi.sh"

print_step "scripts: install connect-bluetooth.sh"
paruS bluez-utils fzf
safe_copy connect-bluetooth.sh "$HOME/.local/bin/connect-bluetooth.sh"

print_step "scripts: install translate-subs"
paruS python-selenium
safe_copy translate-subs "$HOME/.local/bin/translate-subs"

print_step "scripts: install backup"
safe_copy backup "$HOME/.local/bin/backup"

print_step "scripts: install format-drive"
paruS parted
safe_copy format-drive "$HOME/.local/bin/format-drive"

# This needs systemd-resolved configured
print_step "scripts: install bypass_dns_for"
paruS iproute2
safe_copy bypass_dns_for "$HOME/.local/bin/bypass_dns_for"

print_step "scripts: install film"
paruS fzf
safe_copy film "$HOME/.local/bin/film"

print_step "scripts: install film_add_default_subtitles"
paruS ffmpeg
safe_copy film_add_default_subtitles "$HOME/.local/bin/film_add_default_subtitles"
