if __my_bash_check_commands_exist bat; then
    # Colored man pages
    export MANPAGER="sh -c 'col -bx | bat -pl man'"
    export MANROFFOPT='-c'
fi
