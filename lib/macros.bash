[[ -n ${_kzn_macros:-} ]] && return
readonly _kzn_macros=loaded

if [[ $OSTYPE == linux* ]]; then source gnu-macros.bash; else source darwin-macros.bash; fi
