if [ "$(readlink /proc/self/fd/0)" = "/dev/tty1" ]; then
	exec "${HOME}/run-sway.sh"
fi
