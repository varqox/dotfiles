if __my_bash_check_commands_exist git diffr; then
    alias diff="git -c core.pager='diffr --line-numbers aligned | less -R' diff --no-index"
    alias diffs="git -c core.pager='diffr --line-numbers aligned | less -R' diff --no-index --ignore-all-space"
fi
