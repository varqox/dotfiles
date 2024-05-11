#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "locales: enable select locales"
sudo sed 's@^#en_US.UTF-8@en_US.UTF-8@' /etc/locale.gen -i
sudo sed 's@^#en_GB.UTF-8@en_GB.UTF-8@' /etc/locale.gen -i
sudo sed 's@^#pl_PL.UTF-8@pl_PL.UTF-8@' /etc/locale.gen -i

print_step "locales: regenerate"
sudo locale-gen
warn 'Restart all terminals (if you want the change to work immediately)'
