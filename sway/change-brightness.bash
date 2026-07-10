#!/bin/bash
set -euo pipefail

current_percentage="$(brightnessctl --machine-readable info | cut -d , -f 4)"
if [[ "${current_percentage}" == 0% ]] && [[ "${1}" == *+ ]]; then
    swaymsg 'output "eDP-1" dpms on'
fi
current_percentage="$(brightnessctl --machine-readable set "${1}" | cut -d , -f 4)"
if [[ "${current_percentage}" == 0% ]] && [[ "${1}" == *- ]]; then
    swaymsg 'output "eDP-1" dpms off'
fi
