#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "kickoff: install"
paruS kickoff
paruS ttf-hack # font
