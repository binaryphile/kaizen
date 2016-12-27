[[ -n ${_kzn_macros:-} ]] && return
readonly _kzn_macros=loaded

rm='rm -rf --'      # shellcheck disable=SC2034
mkdir='mkdir -p --' # shellcheck disable=SC2034

[[ $OSTYPE == darwin* ]] && source darwin-macros.bash
