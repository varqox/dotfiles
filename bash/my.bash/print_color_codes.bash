#!/usr/bin/bash

function print_color_codes {
    local style
    local start
    local color
    for ((style=0; style<10; ++style)); do
        echo $'\\x1b['"${style}m: "$'\x1b['"${style}m0123456789 "$'\tabcdefgh\x1b[0m'
        for start in 30 40 90 100; do
            for ((color=$((start)); color<$((start + 8)); ++color)); do
                echo $'\\x1b['"${style};${color}m: "$'\x1b['"${style};${color}m0123456789 "$'\tabcdefgh\x1b[0m'
            done
        done
    done

    local fg_or_bg
    local cols
    for fg_or_bg in 3 4; do
        for cols in 6 36; do
            echo $'\\x1b['"${fg_or_bg}8;5;<NUM>m:"
            for ((color=0; color<16; ++color)); do
                printf "\x1b[${fg_or_bg}8;5;${color}m %3s\$\x1b[0m" "${color}"
            done
            echo
            for ((color=16; color<232; ++color)); do
                printf "\x1b[${fg_or_bg}8;5;${color}m %3s\$\x1b[0m" "${color}"
                if (((color - 15) % cols == 0 || color==231)); then
                    echo
                fi
            done
            for ((color=232; color<256; ++color)); do
                printf "\x1b[${fg_or_bg}8;5;${color}m %3s\$\x1b[0m" "${color}"
            done
            echo
        done
    done
}

# Execute function unless sourced
return 0 2> /dev/null || print_color_codes "$@"
