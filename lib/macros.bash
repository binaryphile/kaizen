[[ -n ${_kzn_macros:-} ]] && return
readonly _kzn_macros=loaded

rm='rm -rf --'
mkdir='mkdir -p --'

[[ $OSTYPE == darwin* ]] && source darwin-macros.bash
