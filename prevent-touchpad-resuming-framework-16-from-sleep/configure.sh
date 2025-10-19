#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "framework 16: preventing touchpad resuming from sleep: configure"
if [[ ! -h '/sys/module/i2c_hid_acpi/drivers/i2c:i2c_hid_acpi/i2c-PIXA3854:00' ]]; then
	warn "Device not detected - skipping"
	exit 0
fi

sudo_safe_copy /dev/stdin "/etc/udev/rules.d/prevent-touchpad-resuming-framework-16-from-sleep.rules" << EOF
ACTION=="add", SUBSYSTEM=="i2c", DRIVER=="i2c_hid_acpi", ATTR{name}=="PIXA3854:00", ATTR{power/wakeup}="disabled"
EOF
