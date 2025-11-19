#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"


if ! grep --quiet '^amdgpu ' /proc/modules; then
    warn 'amdgpu module is not loaded -> skipping its configuration'
    exit 0
fi

print_step "amdgpu: install drivers"
paruS mesa vulkan-radeon

print_step "amdgpu: configure"

# TODO: test `amdgpu.dcdebugmask=0x200`(disable PSR-SU) # not enough
# TODO: test `amdgpu.dcdebugmask=0x2`(disable memory stutter mode) # not enough
# TODO: test `amdgpu.dcdebugmask=0x202`(disable PSR-SU and disable memory stutter mode)
# TODO: test `amdgpu.dcdebugmask=0x10` (disable Panel self refresh v1 and PSR-SU)
# TODO: test `amdgpu.dcdebugmask=0x12`(disable Panel self refresh v1 and PSR-SU & disable memory stutter mode) - (alternatively - one of both should help with the issue)

sudo_safe_copy /dev/stdin "/etc/cmdline.d/amdgpu-fix-driver-crashes.conf" <<< "amdgpu.dcdebugmask=0x12"
sudo mkinitcpio -P
