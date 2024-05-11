#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "ssd: set up periodic (weekly) TRIM"
paruS util-linux # for fstrim.timer
sudo systemctl enable fstrim.timer
sudo systemctl restart fstrim.timer
warn "To change the period you need to edit the fstrim.timer systemd's file"
