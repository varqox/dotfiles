#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "thunar: install thunar and utilities"
paruS thunar gvfs tumbler thunar-archive-plugin file-roller thunar-media-tags-plugin

print_step "thunar: configure"
timeout 1 thunar || true # this creates ~/.config/Thunar/uca.xml
# Make "Open Terminal Here" work
sed 's@<command>.*</command>@<command>alacritty --working-directory %f</command>@' -i "$HOME/.config/Thunar/uca.xml"

print_step "thunar: make it a default file browser"
xdg-mime default thunar.desktop inode/directory
# Set it also for dbus calls by unsetting nautilus, this requires restart
mkdir -p ~/.local/share/dbus-1/services/
sed 's@^Exec=.*@Exec=/usr/bin/thunar --gapplication-service@' /usr/share/dbus-1/services/org.freedesktop.FileManager1.service > "$HOME/.local/share/dbus-1/services/org.freedesktop.FileManager1.service"
warn "thunar: making it a default file browser is done, but restart is required"
