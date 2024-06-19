#!/bin/sh

external_display_exists=$([ "$(swaymsg -t get_outputs --pretty --raw | grep '^    "subpixel_hinting":' -c)" = "1" ] || echo yes)
# On Lenovo Thinkpad E480 the directory is AC/, on Framework 16 it is ACDC
is_ac_connected=$([ "$(cat /sys/class/power_supply/AC*/online)" = "1" ] && echo yes)

if [ "${external_display_exists}" = yes ] || [ "${is_ac_connected}" = yes ]; then
    start_activated="true" # inhibit idle
else
    start_activated="false" # allow idle
fi
printf "{\n    \"idle_inhibitor\": {\n        \"start-activated\": ${start_activated},\n    },\n}\n" > $HOME/.config/waybar/idle_inhibitor_start_activated

exec waybar
