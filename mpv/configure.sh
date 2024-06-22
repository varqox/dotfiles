#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "mpv: copy configs"
if cat /proc/cpuinfo | grep '^model name' | grep 'i5-8250U' --quiet; then
	cp mpv.conf "${tmp_dir}/mpv.conf"
	sed -i 's/^profile=gpu-hq/#profile=gpu-hq/' "${tmp_dir}/mpv.conf"
	sed -i 's/^scale=ewa_lanczossharp/#scale=ewa_lanczossharp/' "${tmp_dir}/mpv.conf"
	sed -i 's/^cscale=ewa_lanczossharp/#cscale=ewa_lanczossharp/' "${tmp_dir}/mpv.conf"
	safe_copy "${tmp_dir}/mpv.conf" "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/mpv.conf"
else
	safe_copy --link mpv.conf "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/mpv.conf"
fi
safe_copy --link input.conf "${XDG_CONFIG_HOME:-$HOME/.config}/mpv/input.conf"

print_step "mpv: enable hardware acceleration via VA-API"
case "$(cpu_vendor)" in
	"amd") paruS libva-mesa-driver ;;
	"intel") paruS intel-media-driver ;;
	*) error "Unsupported CPU vendor" ;;
esac
