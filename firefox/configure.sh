#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

ff=firefox

print_step "firefox: run ${ff} briefly to create the default profile"
"${ff}" --headless --screenshot /dev/null

tmp_paruS unzip
function copy_xpi_to() {
	xpi="$1"
	ff_dir="$2"
	extension_id=$(unzip -qc "${xpi}" manifest.json | python -c 'import sys, json; o=json.load(sys.stdin); print(o.get("browser_specific_settings", o.get("applications"))["gecko"]["id"])')
	echo "installing: ${extension_id}"
	mkdir -p "${ff_dir}/extensions"
	cp "${xpi}" "${ff_dir}/extensions/${extension_id}.xpi"
}
tmp_paruS curl
function install_mozilla_org_extension_to() {
	extension_url="$1"
	ff_dir="$2"
	# Extract the xpi URL, but ensure there is only one
	xpi_url=$(curl "${extension_url}" | grep -Po '(?<=href=")https://addons\.mozilla\.org/firefox/downloads/[^"]*\.xpi(?=">Download file</a>)' | awk 'END {if (NR != 1) {exit 1}; print $0}')
	curl "${xpi_url}" --output "${tmp_dir}/x.xpi"
	copy_xpi_to "${tmp_dir}/x.xpi" "${ff_dir}"
}

for prefs_js in ${HOME}/.mozilla/firefox/*/prefs.js; do
	ff_dir="${prefs_js%/prefs.js}"
	print_step "firefox: copy user.prefs"

	if cat /proc/cpuinfo | grep '^model name' | grep 'i5-8250U' --quiet; then
		cp user.js "${tmp_dir}/firefox-user.js"
		sed -i 's@^// user_pref("media.av1.enabled", false);@user_pref("media.av1.enabled", false);@' "${tmp_dir}/firefox-user.js"
		safe_copy "${tmp_dir}/firefox-user.js" "${ff_dir}/user.js"
	else
		safe_copy --link user.js "${ff_dir}/user.js"
	fi

	print_step "firefox: install extensions"
	# These will install after signing in to firefox sync
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/' "${ff_dir}"
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/en-US/firefox/addon/decentraleyes/' "${ff_dir}"
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/en-US/firefox/addon/i-dont-care-about-cookies/' "${ff_dir}"
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/en-US/firefox/addon/istilldontcareaboutcookies/' "${ff_dir}"
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/' "${ff_dir}"
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/en-US/firefox/addon/consent-o-matic/' "${ff_dir}"
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/' "${ff_dir}"
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/en-US/firefox/addon/facebook-container/' "${ff_dir}"
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/' "${ff_dir}"
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/pl/firefox/addon/mutelinks/' "${ff_dir}"
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/en-US/firefox/addon/simple-translate/' "${ff_dir}"
	# install_mozilla_org_extension_to 'https://addons.mozilla.org/en-US/firefox/addon/ctrl-shift-c-should-copy/' "${ff_dir}"

	curl 'https://www.fbpurity.com/fbpurity.THRTYX-WX.xpi' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/114.0' --output "${tmp_dir}/x.xpi"
	copy_xpi_to "${tmp_dir}/x.xpi" "${ff_dir}"
done
