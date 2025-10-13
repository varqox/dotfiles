#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

ff=firefox

tmp_paruS git rust jq curl unzip

print_step "firefox: run ${ff} briefly to create the default profile"
"${ff}" --first-startup --new-instance --headless --screenshot /dev/null

print_step "firefox: change the deafult search engine"
engine_name='Ecosia'
engine_url='https://www.ecosia.org/search?q={searchTerms}'
# Prepare needed tools
git clone https://github.com/varqox/mozlz4 "${tmp_dir}/mozlz4"
(cd "${tmp_dir}/mozlz4" && cargo build)
# Download the icon
favicon_ico_url="${engine_url#*://}"
favicon_ico_url="${engine_url:0:$((${#engine_url} - ${#favicon_ico_url}))}${favicon_ico_url%%/*}/favicon.ico"
favicon_ico_as_base64="$(curl "${favicon_ico_url}" | base64 --wrap=0)"
# Substitute the search engine in each profile
for search_json_mozlz4 in "${HOME}/.mozilla/firefox/"*/search.json.mozlz4; do
    ff_dir="${search_json_mozlz4%/*}"
    profile_name="${ff_dir##*/}"
    print_step "firefox: changing the default search engine for profile ${profile_name}"
    engine_id="$(openssl rand --hex 14 | sed 's/^\(.\{8\}\)\(.\{4\}\)\(.\{4\}\)/\1-\2-\3-/')"
    consent="By modifying this file, I agree that I am doing so only within Firefox itself, using official, user-driven search engine selection processes, and in a way which does not circumvent user consent. I acknowledge that any attempt to change this file from outside of Firefox is a malicious act, and will be responded to accordingly."
    engine_hash="$(printf '%s%s%s' "${profile_name}" "${engine_id}" "${consent}" | openssl sha256 -binary | base64)"

    (
        cd "${tmp_dir}/mozlz4"
        new_json="$(cargo --quiet run -- --extract "${search_json_mozlz4}" - | jq --compact-output '
            del(."engines"[] | select(."_name" == "'"${engine_name}"'"))
            | ."engines" += [
                {
                    "id": "'"${engine_id}"'",
                    "_name": "'"${engine_name}"'",
                    "_loadPath": "[user]",
                    "_iconMapObj": {
                        "48": "data:image/vnd.microsoft.icon;base64,'"${favicon_ico_as_base64}"'"
                    },
                    "_urls": [
                        {
                            "template": "'"${engine_url}"'"
                        }
                    ],
                }
            ]
            | ."metaData"."defaultEngineId" = "'"${engine_id}"'"
            | ."metaData"."defaultEngineIdHash" = "'"${engine_hash}"'"
            | ."metaData"."privateDefaultEngineId" = "'"${engine_id}"'"
            | ."metaData"."privateDefaultEngineIdHash" = "'"${engine_hash}"'"
        ')"
        cargo run -- --compress - "${search_json_mozlz4}" <<< "${new_json}"
    )
done

print_step "firefox: install user preferences"
for prefs_js in "${HOME}/.mozilla/firefox/"*/prefs.js; do
    ff_dir="${prefs_js%/*}"
    profile_name="${ff_dir##*/}"
    print_step "firefox: installing user preferences for profile ${profile_name}"
    if cat /proc/cpuinfo | grep '^model name' | grep 'i5-8250U' --quiet; then
        cp user.js "${tmp_dir}/firefox-user.js"
        sed -i 's@^// \(user_pref("media.av1.enabled", false);\)@\1@' "${tmp_dir}/firefox-user.js"
        safe_copy "${tmp_dir}/firefox-user.js" "${ff_dir}/user.js"
    else
        safe_copy --link user.js "${ff_dir}/user.js"
    fi
done

print_step "firefox: downloading extensions"
ff_extensions=(
    'https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/'
    'https://addons.mozilla.org/en-US/firefox/addon/decentraleyes/'
    'https://addons.mozilla.org/en-US/firefox/addon/i-dont-care-about-cookies/'
    'https://addons.mozilla.org/en-US/firefox/addon/istilldontcareaboutcookies/'
    'https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/'
    'https://addons.mozilla.org/en-US/firefox/addon/consent-o-matic/'
    'https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/'
    'https://addons.mozilla.org/en-US/firefox/addon/facebook-container/'
    'https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/'
    'https://addons.mozilla.org/en-US/firefox/addon/mutelinks/'
    'https://addons.mozilla.org/en-US/firefox/addon/simple-translate/'
)
downloaded_extensions_dir="${tmp_dir}/firefox_extensions/"
mkdir -p "${downloaded_extensions_dir}"
xpi_files=()
for extension_url in "${ff_extensions[@]}"; do
    print_step "firefox: downloading extension: ${extension_url}"
    # Extract the xpi URL, but ensure there is only one
    xpi_url="$(curl "${extension_url}" | grep --only-matching 'href="https://[^"]*\.xpi">Download file<' | sed -n 's/href="//; s/">Download file<$//; x; /./q1; ${x; p}')"
    xpi_file="${downloaded_extensions_dir}/${xpi_url##*/}"
    curl "${xpi_url}" --output "${xpi_file}"
    xpi_files+=("${xpi_file}")
done
# F.B. Purity needs special treatment
print_step "firefox: downloading extension: F.B. Purity"
user_agent_header_for_fb_purity='User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/114.0'
fb_purity_xpi="$(curl 'https://www.fbpurity.com/install.htm' -H "${user_agent_header_for_fb_purity}" | grep --only-matching 'href="[^"]*\.xpi"' | sed -n 's/href="//; s/"$//; 1p')"
fb_purity_xpi_file="${downloaded_extensions_dir}/${fb_purity_xpi##*/}"
curl "https://www.fbpurity.com/${fb_purity_xpi}" -H "${user_agent_header_for_fb_purity}" --output "${fb_purity_xpi_file}"
xpi_files+=("${fb_purity_xpi_file}")

print_step "firefox: installing extensions"
for prefs_js in "${HOME}/.mozilla/firefox/"*/prefs.js; do
    ff_dir="${prefs_js%/*}"
    profile_name="${ff_dir}"
    print_step "firefox: installing extensions for profile ${profile_name}"

    for xpi_file in "${xpi_files[@]}"; do
        extension_id="$(unzip -qc "${xpi_file}" manifest.json |
            python -c 'import sys, json; o=json.load(sys.stdin); print(o.get("browser_specific_settings", o.get("applications"))["gecko"]["id"])'
        )"
        echo "installing: ${extension_id}"
        cp "${xpi_file}" "${ff_dir}/extensions/${extension_id}.xpi"
    done
done
