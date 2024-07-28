#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "pam: lower failed password delay to 0.1s"
# Set the new delay value
sudo sed '/^auth.* pam_faildelay.so .* delay=/d'  /etc/pam.d/system-auth -i # remove the line
sudo sed 's/^\(auth.* pam_faillock.so .* preauth\)/auth       optional                    pam_faildelay.so     delay=100000\n\1/' /etc/pam.d/system-auth -i # add the new delay value line

# First remove the nodelay options
sudo sed 's/^\(auth.* pam_faillock.so .*\) nodelay/\1/' /etc/pam.d/system-auth -i
sudo sed 's/^\(auth.* pam_unix.so .*\) nodelay/\1/' /etc/pam.d/system-auth -i
# Then add the nodelay options so that the modules don't use the default 2s delay
sudo sed 's/^\(auth.* pam_faillock.so .*\)/\1 nodelay/' /etc/pam.d/system-auth -i
sudo sed 's/^\(auth.* pam_unix.so .*\)/\1 nodelay/' /etc/pam.d/system-auth -i
