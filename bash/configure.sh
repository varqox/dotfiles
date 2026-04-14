#!/bin/bash
set -euo pipefail
source "$(dirname -- "$0")/../common.sh"

print_step "bash: copy my.bash configs"
my_bash_dir="${HOME}/.my.bash"
mkdir -p "${my_bash_dir}"
find my.bash/ -mindepth 1 -print0 | while IFS= read -d '' -r path; do
    safe_copy --link "${path}" "${my_bash_dir}/${path##*/}"
done

print_step "bash: activate my.bash in .bashrc"
source_line='source ${HOME}/.my.bash/rc.bash'
if ! grep --quiet "^${source_line}$" "${HOME}/.bashrc"; then
    printf "\n%s\n" "${source_line}" >> "${HOME}/.bashrc"
fi
