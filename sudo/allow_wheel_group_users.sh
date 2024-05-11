#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "sudo: allow wheel group users"
sudo_safe_copy sudoers_wheel "/etc/sudoers.d/wheel"
