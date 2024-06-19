#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "light: install"
paruS light

print_step "light: enable operation without sudo"
sudo usermod --append --groups video "$USER"
