#!/bin/bash
set -e

tmp_dir=$(mktemp -d)
# Kill all background jobs and clean
trap 'kill $(jobs -p) 2> /dev/null; rm -rf ${tmp_dir}' EXIT

# Sudo loop so that sudo won't timeout
sudo -v # If sudo asks for password it will ask now and not fail in the loop below
(while :; do sudo -v; sleep 59; done)&

# Paru
if ! command -v paru > /dev/null; then
    /bin/echo -e '\033[1;32m==>\033[0;1m Installing paru\033[m'
    sudo pacman --noconfirm -S --needed git rust
    git clone https://aur.archlinux.org/paru.git "${tmp_dir}/paru"
    (cd "${tmp_dir}/paru" && makepkg -si --noconfirm)
    paru --gendb
fi

function paruS {
    for pkg in "$@"; do
        paru -Qi "${pkg}" > /dev/null || paru --noconfirm -S --needed "${pkg}"
    done
}

# sudo
echo "%wheel ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/wheel

# Pacman
sudo sed 's@#Color@Color@' /etc/pacman.conf -i
sudo sed 's@#\?ParallelDownloads\s*=.*@ParallelDownloads = 8@' /etc/pacman.conf -i

# Locales
sudo sed 's@^#en_US.UTF-8@en_US.UTF-8@' /etc/locale.gen -i
sudo sed 's@^#en_GB.UTF-8@en_GB.UTF-8@' /etc/locale.gen -i
sudo sed 's@^#pl_PL.UTF-8@pl_PL.UTF-8@' /etc/locale.gen -i
sudo locale-gen
# restart all terminals (if you want the change to work immediately)

# NTP
sudo timedatectl set-ntp true

# Zsh
paruS zsh oh-my-zsh-git
[ "$SHELL" = "/usr/bin/zsh" ] || sudo chsh -s /usr/bin/zsh "${USER}"

# Network manager
sudo systemctl enable --now NetworkManager

# SSD: periodic (weekly) TRIM
paruS util-linux
sudo systemctl enable --now fstrim.timer
# to change the period you need to edit the fstrim.timer systemd's file

# Sway
/bin/echo -e '\033[1;32m==>\033[0;1m Install and setup sway\033[m'
paruS sway
paruS swaybg # for background
paruS waybar # bar
paruS pavucontrol # volume controls manager
paruS pamixer # for volume control shortcuts
paruS light # for brightness control shortcuts
paruS waybar-mpris-git # for media (music and video) control shortcuts
paruS wdisplays # for screen switch shortcut
paruS wlogout # for logging out shortcut
paruS tlp bluez-utils # bluetooth control shortcut
paruS swaylock-effects # screen locker
paruS swayidle # screen lock after idle period
paruS upower # suspending as soon as ac is unconnected
paruS xfce4-terminal # terminal
paruS kickoff # application launcher
# paruS firefox # web browser
# paruS audacious # music player
# paruS sublime-text # text editor
# paruS sublime-merge # graphical git client
# paruS keepassxc # password manager
paruS network-manager-applet # network manager applet
paruS blueman # bluetooth applet
paruS dropbox
paruS grim slurp wl-clipboard # making screenshots
paruS mako libnotify # notifications
paruS xdg-desktop-portal-wlr # screen sharing
# Compile all helper programs
paruS gcc
make -C "${HOME}/.config/sway/"
make -C "${HOME}/.config/waybar/"
# Disable systemd's handling of power button
sudo mkdir -p /etc/systemd/logind.conf.d/; sudo tee /etc/systemd/logind.conf.d/powerkey.conf > /dev/null <<- HEREDOCEND
    [Login]
    HandlePowerKey=ignore
HEREDOCEND
# Disable buggy systemd's handling of suspend on lid close
sudo mkdir -p /etc/systemd/logind.conf.d/; sudo tee /etc/systemd/logind.conf.d/lid.conf > /dev/null <<- HEREDOCEND
    [Login]
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
    HoldoffTimeoutSec=0s
HEREDOCEND

# Pipewire
/bin/echo -e '\033[1;32m==>\033[0;1m Install and setup pipewire and wireplumber\033[m'
paruS pipewire pipewire-pulse pipewire-alsa wireplumber


paruS procps-ng # pkill
paruS htop
paruS ripgrep # rg
paruS fd
paruS man-pages
# TODO: user.js file in the default firefox profile to change settings programmatically instead of having to manually edit about:config (see: https://kb.mozillazine.org/User.js_file)
