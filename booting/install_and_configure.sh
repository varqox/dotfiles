#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

paruS linux linux-lts mkinitcpio cryptsetup sbctl

sudo_safe_copy /dev/stdin /etc/udev/rules.d/any-keyboard-appears.rules << EOF
# KEY env property suffix "ffffffffffe" means that the device reports many keys listed in /usr/include/linux/input-event-codes.h defined as KEY_* starting from KEY_ESC (bits are in reverse order 0x1 in ...fffffffe means KEY_ESC, 0x2 means KEY_1, etc.)
ACTION=="add", KERNEL=="input*", SUBSYSTEM=="input", ENV{KEY}=="*ffffffffffe", TAG+="systemd", ENV{SYSTEMD_ALIAS}+="/dev/any_keyboard"
EOF

sudo_safe_copy /dev/stdin /etc/systemd/system/dev-any_keyboard.device << EOF
[Unit]
JobTimeoutSec=8
EOF

sudo mkdir -p /etc/systemd/system/systemd-cryptsetup@system.service.d/
sudo_safe_copy /dev/stdin /etc/systemd/system/systemd-cryptsetup@system.service.d/wait-for-any-keyboard.conf << EOF
[Unit]
Wants=dev-any_keyboard.device
After=dev-any_keyboard.device
EOF

sudo_safe_copy /dev/stdin /etc/mkinitcpio.d/linux.preset << EOF
# mkinitcpio preset file for the 'linux' package

ALL_kver="/boot/vmlinuz-linux"

PRESETS=('default')

default_uki="/efi/EFI/Linux/arch-linux.efi"
EOF

sudo_safe_copy /dev/stdin /etc/mkinitcpio.d/linux-lts.preset << EOF
# mkinitcpio preset file for the 'linux-lts' package

ALL_kver="/boot/vmlinuz-linux-lts"

PRESETS=('default' 'fallback')

default_uki="/efi/EFI/Linux/arch-linux-lts.efi"

fallback_uki="/efi/EFI/Linux/arch-linux-lts-fallback.efi"
fallback_options="-S autodetect"
EOF

sudo_safe_copy /dev/stdin /etc/mkinitcpio.conf.d/my.conf << EOF
# These ensure that prompt waits for keyboard device being ready (Framework 16 connects keyboard via
# USB and USB devices are reset during initrd startup and it takes around 2s before the keyboard works
# again)
FILES+=(
	/etc/udev/rules.d/any-keyboard-appears.rules
	/etc/systemd/system/dev-any_keyboard.device
	/etc/systemd/system/systemd-cryptsetup@system.service.d/wait-for-any-keyboard.conf
)
# KMS hook is ommited so that there is no flash before decrypting + password prompt appears earlier
HOOKS=(
	systemd
	keyboard
	autodetect # Before autodetect so that keyboards not present now will still work during boot
	microcode
	modconf
	sd-encrypt
	block
	filesystems
	fsck
)
EOF

sudo mkinitcpio -P
