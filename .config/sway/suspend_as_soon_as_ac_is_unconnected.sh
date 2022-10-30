#!/usr/bin/bash
set -e

tmp_dir=$(mktemp -d)
trap 'kill %1 2> /dev/null; rm -r "$tmp_dir"' EXIT

fifo="$tmp_dir/fifo"
mkfifo "$fifo"

upower -m > "$fifo"& # dies from kill %1
UPOWER_PID=$!

# Wait for AC to become detached
echo "x" > "$fifo"& # in case upower printed nothing
cat "$fifo" | while read; do
    if [ "$(cat /sys/class/power_supply/AC/online)" = "0" ]; then
        kill "$UPOWER_PID" # kill upower so that cat exits either by EOF while reading or broken pipe while writing to this while loop
        exit
    fi
done

systemctl suspend
