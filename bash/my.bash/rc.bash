set -uo pipefail

__my_bash_dir="${HOME}/.my.bash/"
__my_bash_timezone='' # Overrides local time zone unless empty e.g. value 'Europe/Warsaw'

function __my_bash_warn {
    if [[ -t 2 ]]; then
        echo $'\x1b[1;33mwarning:\x1b[0m '"$*" >&2
    else
        echo "warning: $*" >&2
    fi
}

function __my_bash_error {
    if [[ -t 2 ]]; then
        echo $'\x1b[1;31merror:\x1b[0m '"$*" >&2
    else
        echo "error: $*" >&2
    fi
}

function __my_bash_check_commands_exist {
    if (($# == 0)); then
        __my_bash_error "Usage: ${FUNCNAME[0]} <COMMAND>"
        return 1
    fi
    declare -i rc=0
    for name in "$@"; do
        local exe_path="$(command -v "${name}")"
        if [[ ! -x "${exe_path}" ]]; then
            __my_bash_warn "${BASH_SOURCE[0]}: missing command ${name}"
            rc=1
        fi
    done
    return $((rc))
}

function __my_bash_date {
    if [[ -z "${__my_bash_timezone}" ]]; then
        date "$@"
    else
        TZ="${__my_bash_timezone}" date "$@"
    fi
}

function my {
    if (($# == 0)); then
        __my_bash_error "Usage ${FUNCNAME[0]} <subcommand> [options]"
        return 1
    fi
    case "${1}" in
        "reload")
            source "${__my_bash_dir}"
            return
            ;;
        *)
            __my_bash_error "${FUNCNAME[0]}: unknown subcommand: ${1}"
            ;;
    esac
}

# Source extra definitions
while IFS= read -d '' -r path; do
    source "${path}"
done < <(find "${__my_bash_dir}" -type f -name '*.bash' -not -name 'rc.bash' -print0)

# Colorful unbuffered grep
alias g='grep --color=auto -P --line-buffered'
alias gi='g --ignore-case'
# Preview files interactively with fzf
if __my_bash_check_commands_exist bat; then
    alias fp='fzf --preview "bat --force-colorization --style numbers {}"'
fi
# Building with lower priority
alias ninja='nice ninja'
alias cargo='nice cargo'
# GDB without startup banner
alias gdb='gdb -q'
# Common ls aliases
alias l='ls -hA'
alias ll='ls -lhAF'
# More frequent watch
alias watch='watch -n 0.25'

######################################### Prompt handling #########################################

# TODO: in tmux: editing if the prompt is in the first line of the screen adds lines above - you
# need to scroll up to see them - it may be connected with \x1b[J and \x1b[2J - both duplicate
# the line at the top in some way

declare -i __MY_BASH_CURRENT_BASH_PID
declare -i __MY_BASH_CURRENT_NESTING_LEVEL
if [[ "${__MY_BASH_CURRENT_BASH_PID-}" != $$ ]]; then
    export __MY_BASH_CURRENT_BASH_PID=$$
    export __MY_BASH_CURRENT_NESTING_LEVEL=$((${__MY_BASH_CURRENT_NESTING_LEVEL:--1} + 1))
fi

__my_bash_prompt_history_file="${__my_bash_dir}/history"
unset __my_bash_prompt_prev_command
unset __my_bash_prompt_prev_command_execution_time

: "${__my_bash_prompt_saved_input:=}" # Set to "" if unset
declare -i __my_bash_prompt_saved_input_consumed_bytes
: "${__my_bash_prompt_saved_input_consumed_bytes:=0}" # Set to 0 if unset

function __my_bash_interactive_prompt {
    local prev_command_exit_status=$?
    local -r prompt_start_time="$(date +%s.%N)"

    # Disable printing of the input from the terminal
    stty --file=/dev/tty -echo

    function __my_bash_prompt_read_available_input {
        local input
        while IFS= read -r -d '' -n 1000000 -t 0.01 input; do
            __my_bash_prompt_saved_input+="${input}"
        done
        __my_bash_prompt_saved_input+="${input}"
    }

    function __my_bash_prompt_await_input {
        if ((__my_bash_prompt_saved_input_consumed_bytes == ${#__my_bash_prompt_saved_input})); then
            __my_bash_prompt_saved_input=''
            __my_bash_prompt_saved_input_consumed_bytes=0
        fi
        local input
        if IFS= read -r -d '' -n 1 input; then
            __my_bash_prompt_saved_input+="${input}"
            __my_bash_prompt_read_available_input
        else
            return
        fi
    }

    # Read pending input
    __my_bash_prompt_read_available_input
    # Move the cursor to the new line if needed, by reading the current cursor position.
    echo -nE $'\x1b[6n' > /dev/tty
    local input
    while true; do
        if ! IFS='' read -r -d R input < /dev/tty; then
            return
        fi

        if [[ "${input}" =~ $'\x1b'\[[0-9]+\;([0-9]+)$ ]]; then
            __my_bash_prompt_saved_input+="${input:0:-${#BASH_REMATCH}}"
            if [[ "${BASH_REMATCH[1]}" != "1" ]]; then
                # Print a red square and a newline
                echo -E $'\x1b[0;41m \x1b[0m' > /dev/tty
            fi
            break
        fi
        __my_bash_prompt_saved_input+="${input}R"
    done

    # Print execution time of the previous command
    if [[ "${__my_bash_prompt_prev_command_execution_time:+x}" == x ]]; then
        # Round to 2 decimal digits
        local dur_nsec=$((3${prompt_start_time#*.} - 1${__my_bash_prompt_prev_command_execution_time#*.} + 5000000))
        local -i dur_sec=$((${prompt_start_time%.*} - ${__my_bash_prompt_prev_command_execution_time%.*} + (dur_nsec / 1000000000) - 2))
        if (( dur_sec > 0 || 1${dur_nsec:1:2} > 109)); then
            local msg=$'\x1b[0;3;90m'"$(__my_bash_date +%T -d "@${prompt_start_time}") "$'\x1b[0;2;3;34mtook \x1b[0;3;34m'"${dur_sec}.${dur_nsec:1:2}"$'\x1b[0;3;90m s'
            if ((dur_sec >= 60)); then
                local msg_s=$'\x1b[0;3;34m'"$((dur_sec % 60)).${dur_nsec:1:2}"$'\x1b[0;3;90m s'

                dur_sec=$((dur_sec / 60))
                local msg_m=$'\x1b[0;3;34m'"$((dur_sec % 60))"$'\x1b[0;3;90m m '

                dur_sec=$((dur_sec / 60))
                local msg_h=''
                if ((dur_sec > 0)); then
                    msg_h=$'\x1b[0;3;34m'"$((dur_sec % 24))"$'\x1b[0;3;90m h '
                fi

                dur_sec=$((dur_sec / 24))
                local msg_d=''
                if ((dur_sec > 0)); then
                    msg_d=$'\x1b[0;3;34m'"$((dur_sec))"$'\x1b[0;3;90m d '
                fi

                msg+=$'\x1b[0m = '"${msg_d}${msg_h}${msg_m}${msg_s}"
            fi
            echo -E "${msg}"$'\x1b[0m' > /dev/tty
        fi
        # Unset previous command start so that if user resets prompt by e.g. Ctrl+c it does not
        # print the previous time over and over again
        unset __my_bash_prompt_prev_command_execution_time
    fi

    local workbuf=''
    local -ir workbuf_bytes_per_char=13
    local -i cursor_pos=0 # cursor block is placed at that pos and editions happen before that index,
                       # e.g. insert at 2 inserts after first 2 characters
    local -i workbuf_len=0
    local -i workbuf_modified_since_printing=0

    function __my_bash_prompt_workbuf_insert_at_cursor {
        # Longest color sequence is of the form "38;5;NNN" where NNN is a number from range [0,255]
        local color=";;;;;;;;${2-}"
        color=$'\x1b[;'"${color: -8}m"
        local suffix="${workbuf:cursor_pos * workbuf_bytes_per_char}"
        local prefix="${workbuf:0:cursor_pos * workbuf_bytes_per_char}"
        for ((i=0;i<"${#1}";++i)); do
            prefix+="${color}${1:i:1}"
        done
        workbuf="${prefix}${suffix}"
        ((cursor_pos += ${#1}))
        ((workbuf_len += ${#1}))
        ((workbuf_modified_since_printing = 1))
    }

    function __my_bash_prompt_workbuf_remove_range {
        local -ir beg=${1:?}
        local -ir end=${2:?}
        if ((beg < end)); then
            if ((beg < cursor_pos)); then
                ((cursor_pos -= end < cursor_pos ? end - beg : cursor_pos - beg))
            fi
            workbuf="${workbuf:0:beg * workbuf_bytes_per_char}${workbuf:end * workbuf_bytes_per_char}"
            ((workbuf_len -= end - beg))
            ((workbuf_modified_since_printing = 1))
        fi
    }

    local ret

    function __my_bash_prompt_set_ret_to_workbuf_range_contents {
        ret="${workbuf:${1:?missing beginning} * workbuf_bytes_per_char:(${2:?missing end parameter} - ${1:?missing beginning parameter}) * workbuf_bytes_per_char}"
        ret="${ret//$'\x1b['??????????}"
    }

    local -i printed_cursor_pos=0

    function __my_bash_prompt_set_ret_to_columns_num {
        ret="${COLUMNS:-$(tput cols)}"
    }

    function __my_bash_prompt_set_ret_to_esc_seq_moving_cursor_to_position {
        if (($# > 1)); then
            local -ir columns="${2}"
        else
            __my_bash_prompt_set_ret_to_columns_num
            local -ir columns=$((ret))
        fi
        local -ir current_cursor_row="$((printed_cursor_pos / columns))"
        local -ir target_cursor_row="$((${1:?missing target position parameter} / columns))"
        if ((target_cursor_row < current_cursor_row)); then
            ret=$'\x1b['"$((current_cursor_row - target_cursor_row))A"
        elif ((target_cursor_row > current_cursor_row)); then
            ret=$'\x1b['"$((target_cursor_row - current_cursor_row))B"
        else
            ret=''
        fi
        ret+=$'\x1b['"$((${1:?missing target position parameter} % columns + 1))G"
    }

    function __my_bash_prompt_reprint_workbuf {
        local decoded_for_printing
        # Max 9 semicolons
        decoded_for_printing="${workbuf//$'\x1b[;;;;;'/$'\x1b[;'}"
        # Max 5 semicolons
        decoded_for_printing="${decoded_for_printing//$'\x1b[;;;'/$'\x1b[;'}"
        # Max 3 semicolons
        decoded_for_printing="${decoded_for_printing//$'\x1b[;;'/$'\x1b[;'}"
        # Max 2 semicolons
        decoded_for_printing="${decoded_for_printing//$'\x1b[;;'/$'\x1b[;'}"
        # Max 1 semicolon
        decoded_for_printing="${decoded_for_printing//$'\x1b[;'/$'\x1b[0;'}"
        decoded_for_printing="${decoded_for_printing//$'\x1b[0;m'/$'\x1b[0m'}"
        __my_bash_prompt_set_ret_to_columns_num
        local -ir columns=$((ret))
        # 1. Move cursor to the beginning of the printed prompt
        __my_bash_prompt_set_ret_to_esc_seq_moving_cursor_to_position 0 $((columns))
        local -r move_cursor_to_prompt_beginning="${ret}"
        # 2. Erase everything after the current position
        # 3. Print the current workbuf and reset colors
        # 4. Print space. This is a quirk workaround that supports terminal size change passively.
        #    The quirk is that if the cursor is after the last character in the current line buffer
        #    (the one that is reflowed if terminal width changes), and the last character is at
        #    the last column, the cursor stays in that column instead of moving to the next line.
        #    Adding space after the cursor makes it behave normally.
        # 4. Move the cursor to the current cursor position
        printed_cursor_pos=$((workbuf_len))
        __my_bash_prompt_set_ret_to_esc_seq_moving_cursor_to_position $((cursor_pos)) $((columns))
        printf "%s%s%s%s%s" \
            "${move_cursor_to_prompt_beginning}" \
            $'\x1b[J' \
            "${decoded_for_printing}"$'\x1b[0m' \
            ' ' \
            "${ret}" > /dev/tty
        ((printed_cursor_pos = cursor_pos))
        ((workbuf_modified_since_printing = 0))
    }

    function __my_bash_prompt_print_above_prompt {
        # 1. Move cursor to the beginning of the printed prompt
        __my_bash_prompt_set_ret_to_esc_seq_moving_cursor_to_position 0
        # 2. Erase everything after the current position
        # 3. Print the message
        printf "%s%s%s" \
            "${ret}" \
            $'\x1b[J' \
            "${1%$'\n'}"$'\n' > /dev/tty
        ((printed_cursor_pos = 0))
        __my_bash_prompt_reprint_workbuf
    }

    function __my_bash_prompt_print_move_cursor_to_position {
        __my_bash_prompt_set_ret_to_esc_seq_moving_cursor_to_position ${1:?missing target cursor position parameter}
        echo -nE "${ret}" > /dev/tty
        ((printed_cursor_pos = ${1:?missing target cursor position parameter}))
    }

    function __my_bash_prompt_print_workbuf {
        if ((workbuf_modified_since_printing == 1)); then
            __my_bash_prompt_reprint_workbuf
        elif ((cursor_pos != printed_cursor_pos)); then
            __my_bash_prompt_print_move_cursor_to_position $((cursor_pos))
        fi
    }

    # Construct the prompt
    if ((__MY_BASH_CURRENT_NESTING_LEVEL != 0)); then
        __my_bash_prompt_workbuf_insert_at_cursor "[${__MY_BASH_CURRENT_NESTING_LEVEL}] "
    fi
    local -ir prompt_time_start_pos=$((cursor_pos))
    __my_bash_prompt_workbuf_insert_at_cursor "$(__my_bash_date +%T -d "@${prompt_start_time}")" "3;90"
    local -ir prompt_time_end_pos=$((cursor_pos))
    __my_bash_prompt_workbuf_insert_at_cursor ' '
    __my_bash_prompt_workbuf_insert_at_cursor "$(id -un)" "1;32" # username
    __my_bash_prompt_workbuf_insert_at_cursor "@" "97"

    local -r hostname="$(uname --nodename)"
    local hostname_hash
    if hostname_hash="$(sha256sum <<< "#####${hostname}")"; then
        local -r hostname_color="1;$((0x${hostname_hash:0:8} % 7 + 90))"
    else
        local -r hostname_color='33'
    fi
    __my_bash_prompt_workbuf_insert_at_cursor "${hostname}" "${hostname_color}"

    __my_bash_prompt_workbuf_insert_at_cursor ":" "97"
    local prompt_cwd="$(pwd)"
    if [[ "${prompt_cwd}" == "${HOME}" ]]; then
        prompt_cwd="~"
    elif [[ "${prompt_cwd}" == "${HOME}"* ]]; then
        prompt_cwd="~${prompt_cwd:${#HOME}}"
    fi
    __my_bash_prompt_workbuf_insert_at_cursor "${prompt_cwd}" "1;34"

    if git rev-parse --git-dir &> /dev/null; then
        local git_commit_hash
        if ! git_commit_hash="$(git rev-parse --short HEAD 2> /dev/null)"; then
            git_commit_hash='empty'
        fi

        local git_tag="$(git tag --sort=-version:refname --points-at HEAD 2> /dev/null | head -n 1)"
        local git_branch
        __my_bash_prompt_workbuf_insert_at_cursor '(' '2'
        if git_branch="$(git symbolic-ref --quiet --short HEAD)"; then
            # Check if current branch equals the upstream branch
            if [[ "$(git rev-parse --short '@{u}' 2> /dev/null)" == "${git_commit_hash}" ]]; then
                __my_bash_prompt_workbuf_insert_at_cursor "${git_branch}" '1;32'
            else
                __my_bash_prompt_workbuf_insert_at_cursor "${git_branch}" '1;33'
            fi
        else
            __my_bash_prompt_workbuf_insert_at_cursor "${git_commit_hash}" '1;95'
        fi
        __my_bash_prompt_workbuf_insert_at_cursor "${git_tag:+ }"
        __my_bash_prompt_workbuf_insert_at_cursor "${git_tag}" '93'
        __my_bash_prompt_workbuf_insert_at_cursor ')' '2'
    fi
    if ((prev_command_exit_status == 0)); then
        __my_bash_prompt_workbuf_insert_at_cursor '$ '
    else
        __my_bash_prompt_workbuf_insert_at_cursor ' '
        local prev_command_exit_status
        if ((prev_command_exit_status <= 128)) || ! prev_command_exit_status="$(kill -l $((prev_command_exit_status - 128)) 2> /dev/null)"; then
            prev_command_exit_status="${prev_command_exit_status}"
        fi
        __my_bash_prompt_workbuf_insert_at_cursor "${prev_command_exit_status}" "38;5;196"
        __my_bash_prompt_workbuf_insert_at_cursor ' '
    fi

    local -ir prompt_len=$((workbuf_len))

    function __my_bash_prompt_user_edit_move_cursor_to {
        ((cursor_pos = ${1:?} < prompt_len ? prompt_len : ${1} > workbuf_len ? workbuf_len : ${1}))
    }

    function __my_bash_prompt_user_edit_remove_range {
        __my_bash_prompt_workbuf_remove_range \
            $((${1:?} < prompt_len ? prompt_len : ${1})) \
            $((${2:?} > workbuf_len ? workbuf_len : ${2}))
    }

    function __my_bash_prompt_user_edit_set_ret_to_pos_after_skipping_backward_from {
        ret="${2:?missing starting pos parameter}"
        while ((ret > prompt_len)); do
            case "${workbuf:ret * workbuf_bytes_per_char - 1:1}" in
                ${1:?missing pattern to skip parameter}) ((--ret)) ;;
                *) break ;;
            esac
        done
    }

    function __my_bash_prompt_user_edit_set_ret_to_pos_after_skipping_forward_from {
        ret="${2:?missing starting pos}"
        while ((ret < workbuf_len)); do
            case "${workbuf:ret * workbuf_bytes_per_char + workbuf_bytes_per_char - 1:1}" in
                ${1:?missing pattern to skip parameter}) ((++ret)) ;;
                *) break ;;
            esac
        done
    }

    function __my_bash_prompt_set_ret_to_command_from_history_using_fzf {
        # Fzf will clear screen after the cursor, to prevent it from hiding the current workbuf,
        # we temporarily move the cursor to the end of the workbuf after ensuring the current
        # contents of the workbuf are printed.
        local -ri saved_cursor_pos=$((cursor_pos))
        ((cursor_pos = workbuf_len))
        __my_bash_prompt_print_workbuf
        local command_from_history
        command_from_history="$({
                # Print history of commands in reverse if history file exists
                exec 2> /dev/null < "${__my_bash_prompt_history_file}" || exit
                flock --shared 0
                exec tac
            } |
                # TODO: pass timezone from ssh, otherwise change to localtime
                TZ="Europe/Warsaw" gawk '{
                        pos = index($0, ":");
                        printf "%s %s\0", strftime("%F %T %a", substr($0, 1, pos - 1)), substr($0, pos + 1);
                    }' |
                fzf --read0 --no-sort --delimiter=' ' --with-nth='{1..3}  {4..}' --nth=4.. --accept-nth='{4..}' --height=25% --highlight-line --wrap --tabstop=4 --query="${1-}"
        )"
        local -ir ec=$?
        ((cursor_pos = saved_cursor_pos))
        __my_bash_prompt_reprint_workbuf # fzf often breaks the printed prompt, so we need to reprint it
        ret="${command_from_history}"
        return ${ec}
    }

    function __my_bash_prompt_complete_path_at_cursor {
        local -r dir="${1/#~/${HOME}}"
        local -r component_prefix="${2?missing path component prefix parameter}"
        local -r component_suffix="${3?missing path component suffix parameter}"
        local -r find_file_flag="${4-}"

        if [[ "${component_suffix}" == */ ]]; then
            # Match only directories (suffixed with /)
            local -r find_args="-type d -printf %P/\0"
        else
            # Match both directories (suffixed with /) and files
            local -r find_args="-type d -printf %P/\0 -or -not -type d ${find_file_flag} -printf %P\0"
        fi

        local completion
        completion="$(find "${dir}" -follow -mindepth 1 -maxdepth 1 ${find_args} |
            sort --zero-terminated --version-sort |
            fzf --sync --read0 --select-1 --reverse --height=25% --highlight-line --wrap --tabstop=4 --bind 'tab:down' --bind 'shift-tab:up' --query="${component_prefix:+^}${component_prefix}${component_prefix:+ }${component_suffix:+"'"}${component_suffix%/}${component_suffix:+ }"
        )"
        ret=$?
        if ((ret == 0)); then
            __my_bash_prompt_user_edit_remove_range $((cursor_pos - ${#component_prefix})) $((cursor_pos + ${#component_suffix}))
            __my_bash_prompt_workbuf_insert_at_cursor "${completion}"
        fi
    }

    function __my_bash_prompt_tab_complete {
        __my_bash_prompt_user_edit_set_ret_to_pos_after_skipping_backward_from '[^ ]' $((cursor_pos))
        local -ir word_start_pos=$((ret))
        __my_bash_prompt_user_edit_set_ret_to_pos_after_skipping_forward_from '[^ ]' $((cursor_pos))
        local -ir word_end_pos=$((ret))
        __my_bash_prompt_set_ret_to_workbuf_range_contents $((word_start_pos)) $((cursor_pos))
        local -r prefix="${ret}"
        __my_bash_prompt_set_ret_to_workbuf_range_contents $((cursor_pos)) $((word_end_pos))
        local -r suffix="${ret}"
        # Check if only whitespace precedes the current word
        __my_bash_prompt_set_ret_to_workbuf_range_contents $((prompt_len)) $((word_start_pos))
        local find_file_flag=''
        if [[ "${ret}" =~ ^\ *$ ]]; then
            # Completing command or path to executable file
            if [[ "${prefix}${suffix}" != */* ]]; then
                # Command
                local completion
                completion="$(
                    {
                        {
                            # Aliases
                            alias -p | sed 's/^alias \([^=]*\)=.*/\1/';
                            # Functions
                            declare -F | sed 's/^declare .* \([^ ]*\)$/\1/';
                        } | tr '\n' '\0'
                        # Executables in $PATH
                        xargs bash -c 'find "$@" -follow -mindepth 1 -maxdepth 1 -type f -executable -printf "%P\0"' - <<< "${PATH//:/$'\n'}"
                        # Directories in CWD
                        find . -follow -mindepth 1 -maxdepth 1 -type d -printf "%P/\0"
                    } |
                        sort --zero-terminated --version-sort |
                        uniq --zero-terminated |
                        fzf --sync --read0 --select-1 --reverse --height=25% --highlight-line --wrap --tabstop=4 --bind 'tab:down' --bind 'shift-tab:up' --query="${prefix:+^}${prefix}${prefix:+ }${suffix:+"'"}${suffix%/}${suffix:+ }"
                )"
                # TODO: fzf clears screen so it could damage prompt part below the current line + we need to print the current workbuf before running fzf so that user sees the current workbuf contents
                ret=$?
                if ((ret == 0)); then
                    __my_bash_prompt_user_edit_remove_range $((word_start_pos)) $((word_end_pos))
                    __my_bash_prompt_workbuf_insert_at_cursor "${completion}"
                fi
                return
            fi
            # Path to executable file
            find_file_flag='-executable'
            # Proceed with completing as path
        fi
        # Completing path
        if [[ -z "${prefix}" ]]; then
            if [[ "${suffix}" == /* ]]; then
                ((++cursor_pos))
                return
            fi
            local dir='.'
        elif [[ "${prefix}" == */* ]]; then
            local dir="${prefix%/*}"
        else
            local dir='.'
        fi
        local component_suffix="${suffix%%/*}"
        if ((${#component_suffix} < ${#suffix})); then
            component_suffix+='/'
        fi
        __my_bash_prompt_complete_path_at_cursor "${dir}" "${prefix##*/}" "${component_suffix}" "${find_file_flag}"
    }

    function __my_bash_prompt_read_single_char_into_ret {
        if ((__my_bash_prompt_saved_input_consumed_bytes < ${#__my_bash_prompt_saved_input})); then
            ret="${__my_bash_prompt_saved_input:__my_bash_prompt_saved_input_consumed_bytes:1}"
            ((++__my_bash_prompt_saved_input_consumed_bytes))
        else
            __my_bash_prompt_saved_input=''
            __my_bash_prompt_saved_input_consumed_bytes=0
            IFS='' read -r -d '' -n 1 "$@" ret
        fi
    }

    local input_char
    local command_from_history
    while true; do
        if ((__my_bash_prompt_saved_input_consumed_bytes == ${#__my_bash_prompt_saved_input})); then
            __my_bash_prompt_saved_input=''
            __my_bash_prompt_saved_input_consumed_bytes=0

            # Ensure the presented prompt is up-to-date
            __my_bash_prompt_print_workbuf

            IFS= read -r -d '' -n 1 input_char || break
            __my_bash_prompt_saved_input+="${input_char}"
            __my_bash_prompt_read_available_input
        fi

        input_char="${__my_bash_prompt_saved_input:__my_bash_prompt_saved_input_consumed_bytes++:1}"
        case "${input_char}" in
            # Printable character
            [\ \!\"\#\$\%\&\'\(\)\*\+\,\-\.\/0-9\:\;\<\=\>\?\@A-Z\[\\\]\^_\`a-z\{\|\}\~])
                __my_bash_prompt_workbuf_insert_at_cursor "${input_char}"
                ;;
            # Ctrl + a
            $'\x01') __my_bash_prompt_user_edit_move_cursor_to 0 ;;
            # Ctrl + d
            $'\x04')
                __my_bash_prompt_prev_command="exit"
                break
                ;;
            # Ctrl + e
            $'\x05') __my_bash_prompt_user_edit_move_cursor_to $((workbuf_len)) ;;
            # Tab
            $'\x09') __my_bash_prompt_tab_complete ;;
            # Ctrl + l
            $'\x0c')
                __my_bash_prompt_print_move_cursor_to_position 0
                # Clear screen
                echo -nE $'\x1b[2J\x1b[H'
                __my_bash_prompt_reprint_workbuf
                ;;
            # Ctrl + r
            $'\x12')
                __my_bash_prompt_set_ret_to_command_from_history_using_fzf
                if (($? == 0)); then
                    __my_bash_prompt_workbuf_insert_at_cursor "${ret}"
                fi
                ;;
            # Ctrl + w, Ctrl + backspace
            $'\x17' | $'\x08')
                __my_bash_prompt_user_edit_set_ret_to_pos_after_skipping_backward_from ' ' $((cursor_pos))
                __my_bash_prompt_user_edit_set_ret_to_pos_after_skipping_backward_from '[^ ]' $((ret))
                __my_bash_prompt_user_edit_remove_range $((ret)) $((cursor_pos))
                ;;
            # Enter
            $'\n')
                __my_bash_prompt_set_ret_to_workbuf_range_contents $((prompt_len)) $((workbuf_len))
                local -r command="${ret}"
                # Save command in history only if it does not start with space
                if ((${#command} > 0)) && [[ "${command:0:1}" != ' ' ]]; then
                    (
                        exec >> "${__my_bash_prompt_history_file}"
                        flock --exclusive 1
                        # Do not add history entry if the last command equals the current one
                        command_from_history="$(tail -n 1 "${__my_bash_prompt_history_file}")"
                        if [[ "${command}" != "${command_from_history#*:}" ]]; then
                            echo "$(date +%s):${command}"
                        fi
                    )
                fi
                __my_bash_prompt_prev_command="${command}"
                __my_bash_prompt_prev_command_execution_time="$(date +%s.%N)"
                break
                ;;
            # Escape sequence
            $'\x1b')
                # Read the escape sequence
                local escape_sequence=''
                if ((__my_bash_prompt_saved_input_consumed_bytes < ${#__my_bash_prompt_saved_input})); then
                    escape_sequence="${__my_bash_prompt_saved_input:__my_bash_prompt_saved_input_consumed_bytes++:1}"
                    case "${escape_sequence}" in
                        '[')
                            while ((__my_bash_prompt_saved_input_consumed_bytes < ${#__my_bash_prompt_saved_input})); do
                                input_char="${__my_bash_prompt_saved_input:__my_bash_prompt_saved_input_consumed_bytes++:1}"
                                escape_sequence+="${input_char}"
                                case "${input_char}" in
                                    # Escape sequence terminator character
                                    [\@A-Z\[\\\]\^_\`a-z\{\|\}\~]) break ;;
                                esac
                            done
                            ;;
                        [\]P\^_X])
                            while ((__my_bash_prompt_saved_input_consumed_bytes < ${#__my_bash_prompt_saved_input})); do
                                input_char="${__my_bash_prompt_saved_input:__my_bash_prompt_saved_input_consumed_bytes++:1}"
                                case "${input_char}" in
                                    $'\x07') break ;;
                                    '\')
                                        if [[ "${escape_sequence}" == *$'\x1b' ]]; then
                                            # Another terminator is $'\x1b' '\'
                                            escape_sequence="${escape_sequence:0:-1}"
                                            break
                                        fi
                                        ;;
                                esac
                                escape_sequence+="${input_char}"
                            done
                            ;;
                    esac
                fi
                # Consume the escape sequence
                case "${escape_sequence}" in
                    # Ctrl + right arrow
                    '[1;5C')
                        __my_bash_prompt_user_edit_set_ret_to_pos_after_skipping_forward_from ' ' $((cursor_pos))
                        __my_bash_prompt_user_edit_set_ret_to_pos_after_skipping_forward_from '[^ ]' $((ret))
                        ((cursor_pos = ret))
                        ;;
                    # Ctrl + left arrow
                    '[1;5D')
                        __my_bash_prompt_user_edit_set_ret_to_pos_after_skipping_backward_from ' ' $((cursor_pos))
                        __my_bash_prompt_user_edit_set_ret_to_pos_after_skipping_backward_from '[^ ]' $((ret))
                        ((cursor_pos = ret))
                        ;;
                    # Delete
                    '[3~') __my_bash_prompt_user_edit_remove_range $((cursor_pos)) $((cursor_pos + 1)) ;;
                    # Up arrow
                    '[A')
                        __my_bash_prompt_set_ret_to_workbuf_range_contents $((prompt_len)) $((cursor_pos))
                        # We now want to search for exact match using fzf
                        # Fzf first checks for trailing $ and trims it, so we need to duplicate it
                        ret="${ret/%\$/\$\$}"
                        # Fzf treats spaces as delimiters, we can escape them with '\\'
                        ret="${ret// /\\ }"
                        # Now, to search literaly we prepend the query with '\''
                        __my_bash_prompt_set_ret_to_command_from_history_using_fzf "${ret:+"'"}${ret}"
                        if (($? == 0)); then
                            __my_bash_prompt_user_edit_remove_range 0 $((workbuf_len))
                            __my_bash_prompt_workbuf_insert_at_cursor "${ret}"
                        fi
                        ;;
                    # Right arrow
                    '[C') __my_bash_prompt_user_edit_move_cursor_to $((cursor_pos + 1)) ;;
                    # Left arrow
                    '[D') __my_bash_prompt_user_edit_move_cursor_to $((cursor_pos - 1)) ;;
                    # Alt + a
                    'a') __my_bash_prompt_user_edit_move_cursor_to 0 ;;
                    # Alt + e
                    'e') __my_bash_prompt_user_edit_move_cursor_to $((workbuf_len)) ;;
                    *)
                        __my_bash_prompt_print_above_prompt $'unrecognized escape sequence:\n'"$(echo -nE $'\x1b'"${escape_sequence}" | xxd)"
                        ;;
                esac
                ;;
            # Backspace
            $'\x7f') __my_bash_prompt_user_edit_remove_range $((cursor_pos - 1)) $((cursor_pos)) ;;
            *)
                __my_bash_prompt_print_above_prompt $'unrecognized input sequence:\n'"$(echo -nE "${input_char}${__my_bash_prompt_saved_input:__my_bash_prompt_saved_input_consumed_bytes}" | xxd)"
                ((__my_bash_prompt_saved_input_consumed_bytes = ${#__my_bash_prompt_saved_input}))
                ;;
        esac
    done

    # Replace time part of the prompt with the current time
    ((cursor_pos = prompt_time_start_pos))
    __my_bash_prompt_workbuf_remove_range $((prompt_time_start_pos)) $((prompt_time_end_pos))
    __my_bash_prompt_workbuf_insert_at_cursor "$(__my_bash_date +%T)" "3;90"
    # Move cursor to the end of the workbuf
    ((cursor_pos = workbuf_len))
    __my_bash_prompt_reprint_workbuf
    # Move cursor to the beginning of the line below the workbuf
    echo > /dev/tty
    # Restore printing of the input from the terminal
    stty --file=/dev/tty echo
}

if [[ -t 0 ]]; then
    # Enable interactive prompt
    PROMPT_COMMAND='__my_bash_interactive_prompt && if [[ "${__my_bash_prompt_prev_command:+x}" == "x" ]]; then eval "${__my_bash_prompt_prev_command}"; fi; eval "${PROMPT_COMMAND}"'
fi
