#!/bin/sh

if [ "$(swaymsg -t get_outputs --pretty --raw | grep '^    "subpixel_hinting":' -c)" = "1" ]; then
    start_activated="false" # no external displays
else
    start_activated="true" # there are external displays
fi
printf "{\n    \"idle_inhibitor\": {\n        \"start-activated\": ${start_activated},\n    },\n}\n" > $HOME/.config/waybar/idle_inhibitor_start_activated

exec waybar
