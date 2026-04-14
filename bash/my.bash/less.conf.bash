export LESS='--RAW-CONTROL-CHARS --quit-if-one-screen'
# Make less use colors if supported
for less_opt in --use-color -DS+ky; do
    if [[ -z "$(less "${less_opt}" 2>&1 <<< '')" ]]; then
        export LESS="${LESS} ${less_opt}"
    fi
done
