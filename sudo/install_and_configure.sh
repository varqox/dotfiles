#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "sudo: install and configure"
sudo true # sudo is a function that will install sudo if not already installed
