if __my_bash_check_commands_exist bat; then
    alias v='bat --force-colorization --paging never'
    alias vl="bat --force-colorization --paging always --pager='less -R'"
fi
