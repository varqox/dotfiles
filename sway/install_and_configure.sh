#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "sway: install sway and utilities"
paruS sway
paruS swaybg # for background
paruS ttf-hack ttf-ubuntu-font-family # fonts
paruS light # for brightness control shortcuts
paruS wdisplays # for screen switch shortcuts
paruS wlogout # for logging out shortcut
paruS tlp # bluetooth command
paruS bluez-utils # for bluetooth control shortcuts (bluetoothctl)
paruS swayidle # screen lock after idle period
paruS network-manager-applet # network manager applet
paruS blueman # bluetooth applet
paruS dropbox # bluetooth applet
paruS grim slurp wl-clipboard # making screenshots
paruS xdg-desktop-portal-wlr # screen sharing
paruS hyprpicker-git # screen color picker
paruS libnotify # notifications

print_step "sway: copy configs and scripts"
safe_copy --link config "${XDG_CONFIG_HOME:-$HOME/.config}/sway/config"
safe_copy --link wallpaper.jpg "${XDG_CONFIG_HOME:-$HOME/.config}/sway/wallpaper.jpg"
safe_copy --link zprofile "$HOME/.zprofile"
safe_copy --link run-sway.sh "${XDG_CONFIG_HOME:-$HOME/.config}/sway/run-sway.sh"
safe_copy --link lock_screen.sh "${XDG_CONFIG_HOME:-$HOME/.config}/sway/lock_screen.sh"
safe_copy --link lock_screen_if_no_external_display.sh "${XDG_CONFIG_HOME:-$HOME/.config}/sway/lock_screen_if_no_external_display.sh"
safe_copy --link toggle_bluetooth.sh "${XDG_CONFIG_HOME:-$HOME/.config}/sway/toggle_bluetooth.sh"
safe_copy --link warn_about_dotfiles_change.sh "${XDG_CONFIG_HOME:-$HOME/.config}/sway/warn_about_dotfiles_change.sh"

tmp_paruS gcc
print_step "sway: build and copy mediactl"
(cd mediactl && ./build.sh)
cp mediactl/mediactl "${XDG_CONFIG_HOME:-$HOME/.config}/sway/mediactl"

tmp_paruS rust
print_step "sway: build and copy sway-workspace-switcher"
(cd sway-workspace-switcher && cargo build --release)
cp --remove-destination sway-workspace-switcher/target/release/sway-workspace-switcher "${XDG_CONFIG_HOME:-$HOME/.config}/sway/sway-workspace-switcher"

print_step "sway: build and copy sway-focus-switcher"
(cd sway-focus-switcher && cargo build --release)
cp --remove-destination sway-focus-switcher/target/release/sway-focus-switcher "${XDG_CONFIG_HOME:-$HOME/.config}/sway/sway-focus-switcher"

swaymsg reload
