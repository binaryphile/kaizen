[[ -n ${_kzn_macros:-} ]] && return
readonly _kzn_macros=loaded

rm='rm -rf --'
mkdir='mkdir -p --'

if [[ $OSTYPE == darwin* ]]; then source darwin-macros.bash; fi
