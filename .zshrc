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

# For crontab -e
export EDITOR=vim

alias l='ls -lAh'
alias o='exo-open'
alias watch='watch -n 0.3'
alias gdb='gdb -q'
alias ninja='nice ninja'
alias dev='bash -c '"'"'(trap "test build/compile_commands.json -nt compile_commands.json && compdb -p build list > compile_commands.json" EXIT; nice ninja -C build $@)'"'"' ninja'
alias cargo='nice cargo'
alias diff='git diff --no-index'
alias dis='git diff --no-index --ignore-all-space'

dt() {
	if [ -z "$1" ] || [[ "$1" =~ ^- ]]; then
		meson test -C build "${@}"
	else
		#meson test -C build $(meson test -C build --list | fzf --filter "$1" | sed 's@ / @:@') "${@:2}"
		local tests=$(meson test -C build --list | fzf --filter "$1" | sed 's@ / @:@')
		meson test -C build --list | (fzf --filter "$1" || echo 'No matching tests' >&2) | sed 's@ / @:@' | xargs --no-run-if-empty meson test -C build "${@:2}"
	fi
}

alias obosim='cd ~/src/obosim/'
alias simlib='cd subprojects/simlib/'

git-rename() {
	git grep -lz -P "$1" | xargs -0 sed -i "s@$1@$2@g"
}

timer() {
	sleep $1 && mpv ~/Dropbox/Documents/Ship_Brass_Bell-Mike_Koenig-1458750630.wav
}

# Warn about dotfiles change
git -C "$HOME" update-index --refresh > /dev/null || false
git -C "$HOME" diff-index --quiet HEAD -- || /bin/echo -e '\033[33mdotfiles changed, for backup purposes review, commit and push the changes\033[m'
[ "$(git -C "$HOME" rev-parse origin/main)" = "$(git -C "$HOME" rev-parse HEAD)" ] || /bin/echo -e '\033[33mdotfiles changes are not pushed\033[m'

function backup() (
	function do_backup() (
		set -e
		# chdir to the parent folder of the specified path
		cd -P -- "$(dirname -- "$1")"
		# Check if specified path is a file or a directory
		local fname=$(basename -- "$1")
		if [ -f "${fname}" ]; then
			local out_file="$HOME/backup/$(echo "${PWD#$HOME/}/${fname}" | sed 's@/@,@g').tar.zst"
			tar --create --zst --file "${out_file}" "${fname}"
		else
			# chdir to the directory
			cd -P -- "${fname}"
			local out_file="$HOME/backup/$(echo "${PWD#$HOME/}" | sed 's@/@,@g').tar.zst"

			function list_git_files() {
				git ls-files -z --cached --recurse-submodules
				git ls-files -z --others --exclude-standard
				PROJECT_DIR=$PWD git submodule foreach --quiet 'git ls-files -z --others --exclude-standard | while read -d "" x; do echo -n "${PWD#$PROJECT_DIR/}/$x"; echo -ne "\0"; done'
				echo -ne '.git\0'
			}
			function ls_all_files() {
				ls --zero --almost-all
			}

			if [ -d '.git/' ]; then
				list_git_files
			else
				ls_all_files
			fi | xargs --null tar --create --zst --file "${out_file}"
		fi
		du -sh "${out_file}"
	)

	if [ -z "$1" ]; then
		do_backup .
	else
		for x in "$@"; do
			do_backup "$x"
		done
	fi
)

alias bp="backup"

function transcode_opus {
	local in_file="$1"
	local out_file="$2"
	if [ -z "${out_file}" ]; then
		out_file="${in_file%.*}.opus"
	fi
	echo -e "Transcoding \033[1m${in_file}\033[m into \033[1m${out_file}\033[m"
	nice ffmpeg -i "${in_file}" -c:a libopus "${out_file}"
	#sox "${in_file}" -t wav - | opusenc - "${out_file}"
}
function transcode_opus_all {
	for x in "$@"; do
		transcode_opus "${x}"
	done
}

function transcode_av1 {
	local in_file="$1"
	local out_file="$2"
	if [ -z "${out_file}" ]; then
		out_file="${in_file%.*}.mkv"
	fi
	echo -e "Transcoding \033[1m${in_file}\033[m into \033[1m${out_file}\033[m"
	nice ffmpeg -i "${in_file}" -c:v libsvtav1 -c:a libopus "${out_file}"
}
function transcode_av1_all {
	for x in "$@"; do
		transcode_av1 "${x}"
	done
}

function transcode_avif {
	local in_file="$1"
	local out_file="$2"
	if [ -z "${out_file}" ]; then
		out_file="${in_file%.*}.avif"
	fi
	echo -e "Transcoding \033[1m${in_file}\033[m into \033[1m${out_file}\033[m"
	nice avifenc -j all "${in_file}" "${out_file}"
}
function transcode_avif_all {
	for x in "$@"; do
		transcode_avif "${x}"
	done
}

alias speedtest='speedtest --secure'
