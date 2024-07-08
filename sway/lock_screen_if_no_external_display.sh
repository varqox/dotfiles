#!/bin/sh
if [ "$(cat /sys/class/drm/card*/status | grep '^connected$' --count)" == 1 ]; then
	exec $HOME/.config/sway/lock_screen.sh
fi
