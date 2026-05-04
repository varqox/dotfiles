#!/bin/bash
set -euo pipefail

# Show the current connection in case only this is needed and the user does not want to type their sudo password.
nmcli device wifi show || true

readonly active_connection="$(
    nmcli --get-values device,name connection show --active |
        sed --silent 's/wlan0://p'
)"

sudo --validate
ssids="$(sudo grep '^Passphrase=' -R /var/lib/iwd/ --files-with-matches |
    sed 's@^/var/lib/iwd/@@; s/\.psk$//' |
    sort --version-sort)"

# Select the current connection
declare -i inital_fzf_pos=1
if [[ -n "${active_connection}" ]]; then
    while IFS= read -r ssid; do
        if [[ "${ssid}" == "${active_connection}" ]]; then
            break;
        fi
        ((++inital_fzf_pos))
    done <<< "${ssids}"
fi

fzf \
    --sort \
    --reverse \
    --bind "load:pos(${inital_fzf_pos})" \
    --preview '
        ssid={}
        password="$(sudo sed --silent 's/^Passphrase=//p' "/var/lib/iwd/${ssid}.psk")"
        echo -e "\x1b[1mSSID:      ${ssid}\x1b[0m"
        echo -e "\x1b[1mPassword:  ${password}\x1b[0m"
        qrencode --level=M --type ANSI256UTF8 --margin=2 "WIFI:S:${ssid};T:WPA;P:${password};H:false;;"
    ' \
    <<< "${ssids}"
