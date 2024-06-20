#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "fonts: install fonts"
paruS ttf-hack ttf-ubuntu-font-family # fonts
paruS glib2 # for gsettings

print_step "fonts: configure"
safe_copy --link fonts.conf "${XDG_CONFIG_HOME:-$HOME/.config}/fontconfig/font.conf"
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 12'
gsettings reset org.gnome.desktop.interface document-font-name
gsettings reset org.gnome.desktop.interface monospace-font-name
gsettings reset org.gnome.desktop.wm.preferences titlebar-font
gsettings reset org.gnome.desktop.interface text-scaling-factor
