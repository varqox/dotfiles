#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "firefox: install"
paruS firefox
paruS ttf-hack
# Video hardware acceleration through VA-API
case "$(cpu_vendor)" in
	"amd") paruS libva-mesa-driver ;;
	"intel") paruS intel-media-driver ;;
	*) error "Unsupported CPU vendor" ;;
esac
paruS hunspell-pl # polish dictionary
paruS hunspell-en_gb # english (United Kingdom) dictionary
paruS hunspell-en_us # english (United States) dictionary
