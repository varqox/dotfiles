#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "pam: faillock: increase locking after 3 attempts to 30 attempts"
sudo sed 's/^\s*#\s*deny\s*=\s*[[:digit:]]*/deny = 30/' -i /etc/security/faillock.conf
