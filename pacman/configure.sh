#!/bin/bash
set -e
source "$(dirname -- "$0")/../common.sh"

print_step "pacman: pacman.conf: enable colors"
sudo sed 's@#Color@Color@' /etc/pacman.conf -i

print_step "pacman: pacman.conf: enable verbose package lists"
sudo sed 's@#VerbosePkgLists@VerbosePkgLists@' /etc/pacman.conf -i

print_step "pacman: pacman.conf: set parallel downloads"
sudo sed 's@#\?ParallelDownloads\s*=.*@ParallelDownloads = 8@' /etc/pacman.conf -i

print_step "pacman: makepkg.conf: enable lto"
sudo sed 's@^\(OPTIONS=(.*\)!\(lto\b\)@\1\2@' /etc/makepkg.conf -i

print_step "pacman: makepkg.conf: make zstd use all threads instead of 1"
sudo sed 's@^\(COMPRESSZST=(zstd.* -q\) \(-)\)@\1 --threads=0 \2@' /etc/makepkg.conf -i

print_step "pacman: makepkg.conf: make Make use all threads"
sudo sed 's@^#\?\(MAKEFLAGS=".*\)-j[0-9]*\(.*"\)@\1-j'"$(nproc)"'\2@' /etc/makepkg.conf -i

