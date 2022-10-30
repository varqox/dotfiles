#!/bin/sh
set -e
cd "$HOME"
while true; do
	git update-index --refresh > /dev/null || true
	git diff-index --quiet HEAD -- || swaynag -t warning -m 'dotfiles changed, for backup purposes review, commit and push the changes'
	[ "$(git rev-parse origin/main)" = "$(git rev-parse HEAD)" ] || swaynag -t warning -m 'dotfiles changes are not pushed'
	sleep 43200 # 12h
done
