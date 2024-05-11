#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

bash decrypt_patch_executable_to_disable_popup.py.age.sh "$tmp_dir/patcher.py"

print_step "sublimehq: install python-pwntools"
paruS python-pwntools

print_step "sublimehq: install pacman hook to patch Sublime Text and Sublime Merge to disable the mildly annoying popup window"
sudo_safe_copy "$tmp_dir/patcher.py" /etc/pacman.d/hooks/patch_sublime.py
sudo_safe_copy patch_sublime.hook /etc/pacman.d/hooks/patch_sublime.hook

print_step "sublimehq: patch Sublime Text and Sublime Merge to disable the mildly annoying popup window"
for executable in /opt/sublime_text/sublime_text /opt/sublime_merge/sublime_merge; do
	cp "${executable}" "$tmp_dir/exe"
	python "/etc/pacman.d/hooks/patch_sublime.py" "$tmp_dir/exe"
	cp --remove-destination "$tmp_dir/exe" "${executable}" 2> /dev/null ||
		sudo cp --remove-destination "$tmp_dir/exe" "${executable}"
done
