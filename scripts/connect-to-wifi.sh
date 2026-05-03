#!/bin/bash

readonly refresh_interval_sec=0.25
readonly action='
    nmcli device wifi rescan &&
    nmcli --color yes --fields in-use,ssid,chan,freq,signal,bars,security,bssid,ssid-hex device wifi list |
    sed "s/^\(\x1b[^a-z]*[a-z]\)\*\(\x1b[^a-z]*[a-z]\)     /\1----->\2/"
'

ssid_hex="$(eval "${action}" |
    fzf \
        --ansi \
        --delimiter '\s+' \
        --with-nth ..-2 \
        --accept-nth -1 \
        --no-sort \
        --reverse \
        --header-lines=1 \
        --bind "load:reload-sync:sleep "${refresh_interval_sec}" && ${action}" \
        --bind 'down:unbind(load)+down' \
        --bind 'up:unbind(load)+up'
)"

if [ -n "${ssid_hex}" ]; then
    ssid="$(xxd -ps -r <<< "${ssid_hex}")"
    echo "Connecting to ${ssid}..." >&2
    if {
        nmcli connection up --ask "${ssid}" 2>&1
        (($? == 10))
    }; then
        nmcli device wifi connect --ask "${ssid}"
    fi
fi
