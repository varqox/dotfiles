#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "ntp: enable network time synchronization"
sudo timedatectl set-ntp true
