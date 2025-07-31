#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "firefox: install"
paruS firefox
paruS ttf-hack
# Video hardware acceleration through VA-API
case "$(cpu_vendor)" in
	"amd") paruS mesa vulkan-radeon ;;
	"intel") paruS intel-media-driver vulkan-intel ;;
	*) error "Unsupported CPU vendor" ;;
esac
paruS hunspell-pl # polish dictionary
paruS hunspell-en_gb # english (United Kingdom) dictionary
paruS hunspell-en_us # english (United States) dictionary

print_step "firefox: set it as a default web-browser"
xdg-settings set default-web-browser firefox.desktop
xdg-mime default firefox.desktop text/html
