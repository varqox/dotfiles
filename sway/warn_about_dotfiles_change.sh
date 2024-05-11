#!/bin/bash
set -euo pipefail
cd "$HOME/dotfiles"
git update-index --refresh > /dev/null || true
git diff-index --quiet HEAD -- || swaynag -t warning -m 'dotfiles changed, for backup purposes review, commit and push the changes'
[ "$(git rev-parse origin/main)" = "$(git rev-parse HEAD)" ] || swaynag -t warning -m 'changes of dotfiles are not pushed'
