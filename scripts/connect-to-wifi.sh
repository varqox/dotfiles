#!/bin/sh
wifi_name=$(iwctl station wlan0 scan > /dev/null; iwctl station wlan0 get-networks |
	tail -n +5 | # remove table headers
	sed "s/\x1b\[\(0m\|1;90m\**\)//g" | # remove colors
	grep -v '^No networks available$' | # remove message when there are no networks
	sed "s/^......//" | grep -v "^$" | # remove padding and prompt
	fzf --reverse --no-sort --bind 'load:reload-sync:sleep 0.3; iwctl station wlan0 scan > /dev/null; iwctl station wlan0 get-networks | tail -n +5 | sed "s/\x1b\[\(0m\|1;90m\**\)//g" | grep -v "^No networks available\$" | sed "s/^......//" | grep -v "^$" || true' --bind 'down:unbind(load)+down' --bind 'up:unbind(load)+up' |
	sed 's/  *\([[:graph:]]*\)  *\(\*\**\) *$//g') # extract network name by removing everything after the network name (space-proof method)
if [ ! -z "${wifi_name}" ]; then
	echo "Connecting to: ${wifi_name}..."
	exec iwctl station wlan0 connect "${wifi_name}"
fi
