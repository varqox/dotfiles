SHELL = /bin/sh
# Makes shell execute every command with CWD = directory containing the makefile
.SHELLFLAGS = -c 'cd $(dir $(abspath $(lastword $(MAKEFILE_LIST)))); exec $$SHELL -c "$$0"'

.PHONY: all
all: paru
all: pacman
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

paru: FORCE
	paru/install.sh
	paru/configure.sh

install-%: FORCE paru
	bash -c 'source common.sh; print_step "install: $*"; paruS $*'

pacman: FORCE
	pacman/configure.sh

sudo: FORCE
	sudo/install_and_configure.sh

pam: FORCE
	pam/lower_failed_password_delay.sh
	pam/increase_faillock.sh

locales: FORCE
	locales/configure.sh

networkmanager: FORCE
	networkmanager/install.sh
	networkmanager/configure.sh

dns: FORCE
	dns/install_and_configure.sh

ssd: FORCE
	ssd/set_up_periodic_trim.sh

ntp: FORCE
	ntp/enable.sh

earlyoom: FORCE
	earlyoom/install_and_configure.sh

tlp: FORCE
	tlp/install_and_configure.sh

tdp: FORCE
	tdp/install_and_configure.sh

prevent-touchpad-resuming-framework-16-from-sleep: FORCE
	prevent-touchpad-resuming-framework-16-from-sleep/configure.sh

zsh: FORCE install-zsh nvim
	zsh/configure.sh

tmux: FORCE
	tmux/install_and_configure.sh

scripts: FORCE
	scripts/install.sh

nvim: FORCE
	nvim/install_and_configure.sh

git: FORCE install-git nvim
	git/configure.sh

pipewire: FORCE
	pipewire/install.sh

systemd: FORCE
	systemd/disable_handling_of_power_button.sh
	systemd/disable_handling_of_suspend_on_lid_close.sh

fonts: FORCE
	fonts/install_and_configure.sh

alacritty: FORCE
	alacritty/install.sh
	alacritty/configure.sh

thunar: FORCE alacritty
	thunar/install_and_configure.sh

kickoff: FORCE
	kickoff/install.sh
	kickoff/configure.sh

mako: FORCE install-mako fonts
	mako/configure.sh

keepassxc: FORCE install-keepassxc install-qt5-wayland fonts

sway: FORCE networkmanager scripts pipewire systemd fonts swaylock waybar alacritty kickoff mako keepassxc thunar
	sway/install_and_configure.sh

swaylock: FORCE
	swaylock/install.sh
	swaylock/configure.sh

waybar: FORCE pipewire alacritty networkmanager
	waybar/install.sh
	waybar/configure.sh

sublime-text: FORCE install-sublime-text-4 fonts
	sublime-text/configure.sh

sublime-merge: FORCE install-sublime-merge fonts
	sublime-merge/configure.sh

zed: FORCE fonts
	zed/install_and_configure.sh

meson: FORCE
	meson/install_and_configure.sh

firefox: FORCE fonts thunar
	firefox/install.sh
	firefox/configure.sh

audacious: FORCE install-audacious fonts
	audacious/configure.sh

age: FORCE
	age/install_and_configure.sh

mpv: FORCE
	mpv/install.sh
	mpv/configure.sh
	mpv/install-plugin-auto-save-state.sh
	mpv/install-plugin-autosub.sh
	mpv/install-plugin-autosubsync.sh

sublimehq: FORCE sublime-text sublime-merge age
	sublimehq/install_and_run_pacman_hook_patching_sublime_executables.sh
