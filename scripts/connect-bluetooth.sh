#!/bin/sh

bluetoothctl scan on > /dev/null &
bluetoothctl devices |
	sed "s/^Device //" |
	fzf --reverse --no-sort --bind 'load:reload-sync:sleep 0.3; bluetoothctl devices | sed "s/^Device //"' --bind 'down:unbind(load)+down' --bind 'up:unbind(load)+up' |
	cut --delimiter=' ' --fields=1 | # extract the device address
	xargs bluetoothctl connect 
