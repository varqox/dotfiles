#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "pipewire: install PipeWire and WirePlumber"
paruS pipewire-pulse pipewire-alsa wireplumber
