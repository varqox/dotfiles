#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "pipewire: install PipeWire and WirePlumber"
paruS pipewire-pulse pipewire-alsa wireplumber
