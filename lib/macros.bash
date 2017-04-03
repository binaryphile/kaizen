[[ -n ${_kzn_macros:-} ]] && return
readonly _kzn_macros=loaded

rm='rm -rf --'
mkdir='mkdir -p --'
install='install  -m  644 --'
installd='install -dm 755 --'
installx='install -m  755 --'

if [[ $OSTYPE == darwin* ]]; then source darwin-macros.bash; fi
