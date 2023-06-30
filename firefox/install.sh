#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "firefox: install"
paruS firefox-developer-edition
paruS ttf-hack
paruS intel-media-driver # Video hardware acceleration under Wayland for Intel integrated GPUs
paruS hunspell-pl # polish dictionary
paruS hunspell-en_gb # english (United Kingdom) dictionary
paruS hunspell-en_us # english (United States) dictionary
