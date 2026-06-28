#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

readonly swapfile_path="/swapfile"
readonly swapfile_compressor=lz4 # lzo or lz4 (kernels since 6.19)
readonly hibernate_during_suspend_after=2h # e.g. 30min

if cat /proc/swaps | tail --lines +2 | cut -d ' ' -f 1 | grep --quiet --fixed-strings "${swapfile_path}"; then
    print_step "hibernation: disabling swapfile ${swapfile_path}"
    sudo swapoff "${swapfile_path}"
fi

print_step "hibernation: creating swapfile ${swapfile_path}"

ram_size_in_bytes="$(free --bytes | sed --silent 's/^Mem:\s\+\([0-9]\+\)\s.*/\1/p')"
sudo fallocate --length "${ram_size_in_bytes}" "${swapfile_path}"
sudo chmod 600 "${swapfile_path}"
sudo mkswap "${swapfile_path}"

print_step "hibernation: activating swapfile ${swapfile_path}"

# Make sure kernel uses swap only for hibernation by discouraging its use as much as possible
sudo sysctl --quiet "vm.swappiness=0"
sudo swapon "${swapfile_path}"

print_step "hibernation: update cmdline to enable hibernation"

uuid_of_partition_containing_swapfile="$(findmnt --noheadings --output UUID --target "${swapfile_path}")"
swapfile_physical_offset="$(sudo filefrag -v "${swapfile_path}" |
    grep '^\s*ext:\s\+logical_offset:\s\+physical_offset:' -A 1 |
    tail --lines 1 |
    sed 's/^\s\+0:\s\+0\.\.\s\+0:\s\+\([0-9]\+\)\.\..*/\1/'
)"
sudo cp /dev/stdin /etc/cmdline.d/hibernation.conf << EOF
# Resume partition is specified by UUID not to race with dm-crypt
resume=UUID=${uuid_of_partition_containing_swapfile}
# Resume offset is the position of the first byte of the swapfile on that partition
resume_offset=${swapfile_physical_offset}
# Compressor
hibernate.compressor=${swapfile_compressor}
# Make the kernel don't use the swapfile for anything else than hibernation
sysctl.vm.swappiness=0
# Makes amdgpu driver reset itself if it hangs during resume - only needed during resuming from hibernation.
amdgpu.gpu_recovery=1
# Fix issues with thunderbolt dock unplugging / replugging during suspend and hibernation
pcie_aspm=off
EOF

print_step "hibernation: install script to fix state after resuming from hibernation"
sudo cp /dev/stdin /etc/systemd/system/hibernation-resume-fix-sway-desktop.service << 'EOF'
[Unit]
Description=Fix sway desktop state after resuming from hibernation
After=hibernate.target suspend-then-hibernate.target

[Service]
Type=oneshot
ExecCondition=/usr/bin/bash -c '/usr/bin/dmesg | /usr/bin/grep -E " PM: (suspend|hibernation: hibernation) exit" | tail -n 1 | /usr/bin/grep --quiet "hibernation exit"'
# Unlock session
ExecStart=-/usr/bin/loginctl unlock-sessions
# Dissmiss swaylock
ExecStart=-/usr/bin/pkill -USR1 swaylock
# Fix bluetooth
ExecStart=-/usr/bin/systemctl restart bluetooth.service
# Fix sway GPU state
ExecStart=-/usr/bin/bash -c 'set -x; eval "$(ps -eo comm,user,uid,pid | awk \'$1=="sway" { print "sudo -u " $2 " SWAYSOCK=/run/user/" $3 "/sway-ipc." $3 "." $4 ".sock swaymsg \\"output * dpms off; output * dpms on\\""; exit }\')"'

[Install]
WantedBy=hibernate.target suspend-then-hibernate.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable hibernation-resume-fix-sway-desktop.service

print_step "hibernation: applying the cmdline updates to the currently running kernel"

lsblk --noheadings --raw --output MAJ:MIN "/dev/disk/by-uuid/${uuid_of_partition_containing_swapfile}" |
    sudo cp /dev/stdin /sys/power/resume
sudo cp /dev/stdin /sys/power/resume_offset <<< "${swapfile_physical_offset}"
sudo cp /dev/stdin /sys/module/hibernate/parameters/compressor <<< "${swapfile_compressor}"
sudo sysctl --quiet "vm.swappiness=0"
# amdgpu.gpu_recovery=1 is only needed during resuming from hibernation.
# pcie_aspm=off to my best knowledge has no runtime equivalent

print_step "hibernation: updating initrams to account for cmdline changes"
sudo mkinitcpio -P

print_step "hibernation: setting up suspend-then-hibernate"
sudo cp /dev/stdin /etc/systemd/sleep.conf.d/hibernate.conf << EOF
[Sleep]
HibernateDelaySec=${hibernate_during_suspend_after}
EOF
sudo cp /dev/stdin /etc/systemd/logind.conf.d/hibernate.conf << EOF
[Login]
HandleLidSwitch=suspend-then-hibernate
HandleLidSwitchExternalPower=suspend-then-hibernate
EOF
sudo systemctl reload systemd-logind
