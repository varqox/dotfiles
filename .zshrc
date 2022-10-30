# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/
ZSH_THEME="mh"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

HISTSIZE=100000000
SAVEHIST=100000000
HIST_STAMPS="yyyy-mm-dd"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh

# Changes how Ctrl+W works by making words space-separated
autoload -Uz select-word-style
select-word-style shell

PATH="/usr/lib/ccache/bin:$PATH:$HOME/.local/bin"
PATH="$PATH:/usr/share/clang/" # Add run-clang-tidy.py and all to PATH
ulimit -c 0 # disable core dumps, but allow enabling them on demand with ulimit -c unlimited

export GCC_COLORS="auto" # for GCC to color diagnostic messages in conjuntion with ccache

# Color in man pages
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

alias l="ls -lAh"
alias watch='watch -n 0.3 '
alias gdb='gdb -q'
alias ninja='nice ninja'
alias dev='bash -c '"'"'(trap "test build/compile_commands.json -nt compile_commands.json && compdb -p build list > compile_commands.json" EXIT; nice ninja -C build $@)'"'"' ninja'

alias obosim='cd ~/src/obosim/'
alias simlib='cd subprojects/simlib/'

git-rename() {
	git grep -lz -P "$1" | xargs -0 sed -i "s@$1@$2@g"
}

timer() {
	sleep $1 && mpv ~/Dropbox/Documents/Ship_Brass_Bell-Mike_Koenig-1458750630.wav
}
