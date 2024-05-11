#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "earlyoom: install"
paruS earlyoom

print_step "earlyoom: configure"
sudo sed 's/^\(EARLYOOM_ARGS="-r 3600\) \(-n --avoid .*\)/\1 -p -m 1 -s 100 \2/' -i /etc/default/earlyoom

print_step "earlyoom: enable and restart"
sudo systemctl enable earlyoom.service
sudo systemctl restart earlyoom.service
