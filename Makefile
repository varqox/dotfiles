SHELL = /bin/sh
# Makes shell execute every command with CWD = directory containing the makefile
.SHELLFLAGS = -c 'cd $(dir $(abspath $(lastword $(MAKEFILE_LIST)))); exec $$SHELL -c "$$0"'

.PHONY: all
all: keyd
all: paru
all: pacman
all: booting
all: hibernation
all: sudo
all: pam
all: locales
all: dns
all: networkmanager
all: ssd
all: ntp
all: earlyoom
all: tlp
all: tdp
all: prevent-touchpad-resuming-framework-16-from-sleep
all: zsh
all: tmux
all: scripts
all: nvim
all: git
all: pipewire
all: systemd
all: fonts
all: thunar
all: sway
all: sublime-text
all: sublime-merge
all: zed
all: meson
all: firefox
all: audacious
all: age
all: mpv
all: sublimehq
all: ticktick
all: beeper
all: install-procps-ng # pkill
all: install-htop
all: install-ripgrep # rg
all: install-fd
all: install-man-pages
all: install-gcc
all: install-clang
all: install-gdb
all: install-mold

# Make make silent by default
ifndef VERBOSE
.SILENT:
endif

.PHONY: FORCE
FORCE:

keyd: FORCE
	keyd/install_and_configure.sh < /dev/tty

pacman: FORCE
	pacman/configure.sh < /dev/tty

paru: pacman FORCE
	paru/install.sh < /dev/tty
	paru/configure.sh < /dev/tty

booting: FORCE
	booting/install_and_configure.sh < /dev/tty

hibernation: FORCE booting
	hibernation/install_and_configure.sh < /dev/tty

install-%: FORCE paru
	bash -c 'source common.sh; print_step "install: $*"; paruS $*'  < /dev/tty

sudo: FORCE
	sudo/install_and_configure.sh < /dev/tty

pam: FORCE
	pam/lower_failed_password_delay.sh < /dev/tty
	pam/increase_faillock.sh < /dev/tty

locales: FORCE
	locales/configure.sh < /dev/tty

networkmanager: FORCE
	networkmanager/install.sh < /dev/tty
	networkmanager/configure.sh < /dev/tty

dns: FORCE
	dns/install_and_configure.sh < /dev/tty

ssd: FORCE
	ssd/set_up_periodic_trim.sh < /dev/tty

ntp: FORCE
	ntp/enable.sh < /dev/tty

earlyoom: FORCE
	earlyoom/install_and_configure.sh < /dev/tty

tlp: FORCE
	tlp/install_and_configure.sh < /dev/tty

tdp: FORCE
	tdp/install_and_configure.sh < /dev/tty

prevent-touchpad-resuming-framework-16-from-sleep: FORCE
	prevent-touchpad-resuming-framework-16-from-sleep/configure.sh < /dev/tty

zsh: FORCE install-zsh nvim
	zsh/configure.sh < /dev/tty

tmux: FORCE
	tmux/install_and_configure.sh < /dev/tty

scripts: FORCE
	scripts/install.sh < /dev/tty

nvim: FORCE
	nvim/install_and_configure.sh < /dev/tty

git: FORCE install-git nvim
	git/configure.sh < /dev/tty

pipewire: FORCE
	pipewire/install.sh < /dev/tty

systemd: FORCE
	systemd/disable_handling_of_power_button.sh < /dev/tty
	systemd/disable_handling_lid_events_when_plugged_or_docked.sh < /dev/tty

fonts: FORCE
	fonts/install_and_configure.sh < /dev/tty

alacritty: FORCE
	alacritty/install.sh < /dev/tty
	alacritty/configure.sh < /dev/tty

thunar: FORCE alacritty
	thunar/install_and_configure.sh < /dev/tty

kickoff: FORCE
	kickoff/install.sh < /dev/tty
	kickoff/configure.sh < /dev/tty

mako: FORCE install-mako fonts
	mako/configure.sh < /dev/tty

keepassxc: FORCE install-keepassxc install-qt5-wayland fonts

sway: FORCE keyd networkmanager scripts pipewire systemd fonts swaylock waybar alacritty kickoff mako keepassxc thunar hibernation
	sway/install_and_configure.sh < /dev/tty

swaylock: FORCE
	swaylock/install.sh < /dev/tty
	swaylock/configure.sh < /dev/tty

waybar: FORCE pipewire alacritty networkmanager
	waybar/install.sh < /dev/tty
	waybar/configure.sh < /dev/tty

sublime-text: FORCE install-sublime-text-4 fonts
	sublime-text/configure.sh < /dev/tty

sublime-merge: FORCE install-sublime-merge fonts
	sublime-merge/configure.sh < /dev/tty

zed: FORCE fonts
	zed/install_and_configure.sh < /dev/tty

meson: FORCE
	meson/install_and_configure.sh < /dev/tty

firefox: FORCE fonts thunar dns
	firefox/install.sh < /dev/tty
	firefox/configure.sh < /dev/tty

audacious: FORCE install-audacious fonts
	audacious/configure.sh < /dev/tty

age: FORCE
	age/install_and_configure.sh < /dev/tty

mpv: FORCE
	mpv/install.sh < /dev/tty
	mpv/configure.sh < /dev/tty
	mpv/install-plugin-auto-save-state.sh < /dev/tty
	mpv/install-plugin-autosub.sh < /dev/tty
	mpv/install-plugin-autosubsync.sh < /dev/tty

sublimehq: FORCE sublime-text sublime-merge age
	sublimehq/install_and_run_pacman_hook_patching_sublime_executables.sh < /dev/tty

ticktick: FORCE
	ticktick/install_and_configure.sh < /dev/tty

beeper: FORCE
	beeper/install_and_configure.sh < /dev/tty
