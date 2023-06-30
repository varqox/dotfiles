#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "waybar: install"
paruS waybar
paruS waybar-mpris-git # for media (music and video) control shortcuts
paruS pavucontrol # volume controls manager
paruS light # for brightness control
paruS upower # for event-driven battery status
paruS ttf-roboto ttf-hack # fonts
paruS otf-font-awesome # icons
