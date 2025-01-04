#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "tdp: install"
case "$(cpu_vendor)" in
	"amd") paruS ryzenadj-git ;;
	"intel") error "unsupported for now" ;;
esac

print_step "tdp: install udev rule"
sudo_safe_copy "tdp-$(cpu_vendor).rules" "/etc/udev/rules.d/tdp.rules"

case "$(cpu_vendor)" in
	"amd") {
		print_step "tdp: enabling iomem=relaxed kernel parameter for ryzenadj to work"
		sudo_safe_copy /dev/stdin "/etc/cmdline.d/for-ryzenadj.conf" <<< "iomem=relaxed"
		sudo mkinitcpio -P
	} ;;
	"intel") error "unsupported for now" ;;
esac
