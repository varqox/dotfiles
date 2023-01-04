#!/bin/sh
if [ "$(swaymsg -t get_outputs --pretty --raw | grep '^    "subpixel_hinting":' -c)" = "1" ]; then
	exec $HOME/.config/sway/lock_screen.sh
fi
