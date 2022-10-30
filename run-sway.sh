#!/bin/zsh

# Sway sets XDG_SESSION_TYPE=wayland
# But, sway does NOT set XDG_CURRENT_DESKTOP
# XDG_CURRENT_DESKTOP is required by some apps e.g. by xdg-desktop-portal (a dbus service which is told to import this variable within sway config), otherwise GTK apps start after 20 seconds without this
#export XDG_CURRENT_DESKTOP=sway # TODO: check if this is necessary here, or we can just set it for the dbus

# Makes firefox use native wayland (no matter how it is started)
export MOZ_ENABLE_WAYLAND=1
# Together with the MOZ_ENABLE_WAYLAND enables apps running under xwayland to open URLs in a wayland firefox
export MOZ_DBUS_REMOTE=1

# systemd-cat redirects stdout and stderr to journal
# To access journal use: journalctl --user -t sway
systemd-cat --identifier=sway sway
