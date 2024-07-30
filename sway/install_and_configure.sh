#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "sway: install sway and utilities"
paruS sway
paruS swaybg # for background
paruS ttf-hack ttf-ubuntu-font-family # fonts
paruS wdisplays # for screen switch shortcuts
paruS wlogout # for logging out shortcut
paruS tlp # bluetooth command
paruS bluez-utils # for bluetooth control shortcuts (bluetoothctl)
paruS wtype inotify-tools # for remapping sequence of keys into other sequences
paruS swayidle # screen lock after idle period
paruS network-manager-applet # network manager applet
paruS blueman # bluetooth applet
paruS dropbox python-gpgme gnome-shell-extension-appindicator # dropbox with dependencies
paruS grim slurp wl-clipboard # making screenshots
paruS xdg-desktop-portal-wlr # screen sharing
paruS hyprpicker-git # screen color picker
paruS libnotify # notifications
paruS eog # image viewer
paruS evince # PDF viewer

print_step "sway: copy configs and scripts"
# Get the laptop's display name and resolution
edp_name="eDP-1"
edp_mode="$(head -n 1 /sys/class/drm/card1-eDP-1/modes)"
edp_width="$(sed 's/x.*//' <<< "$edp_mode")"
edp_height="$(sed 's/^.*x//' <<< "$edp_mode")"
# External display name and resolution
external_name="Microstep MAG274UPF CC2H454200402"
external_width=3840
external_height=2160
# Calculate positions of where to place the displays
highest_height=$((edp_height > external_height ? edp_height : external_height))
external_x=0
external_y=$((highest_height - external_height))
edp_x=${external_width}
edp_y=$((highest_height - edp_height))
# Rewrite and install the sway config
cp config "${tmp_dir}/sway-config"
sed -i "s/^# <<output laptop>$/output \"${edp_name}\" mode ${edp_width}x${edp_height} adaptive_sync on pos ${edp_x} ${edp_y}/" "${tmp_dir}/sway-config"
sed -i "s/^# <<output external monitor>>$/output \"${external_name}\" mode ${external_width}x${external_height}@144.000Hz adaptive_sync on pos ${external_x} ${external_y}/" "${tmp_dir}/sway-config"
safe_copy "${tmp_dir}/sway-config" "${XDG_CONFIG_HOME:-$HOME/.config}/sway/config"
# Other configs
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
