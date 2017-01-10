[[ -n ${_shpec_helper:-} ]] && return
readonly _shpec_helper=loaded

source import.bash

eval "$(importa kzn '( absolute_path dirname )')"

cleanup() {
  eval "$(passed '( path )' "$@")"
  validate_dirname path || return
  $rm "$path"
}

initialize_shpec_helper() {
  local tmp=$HOME/tmp

  umask 002
  rm='rm -rf --'
  mkdir='mkdir -p --'
  ln='ln -sfT --'

  $mkdir "$tmp"
  mktemp='mktemp -qp '"$tmp"
  mktempd='mktemp -qdp '"$tmp"

  unset -v CDPATH
}

shpec_source() {
  eval "$(passed '( path )' "$@")"
  local parent_dir

  parent_dir=$(absolute_path "$(dirname "$BASH_SOURCE")"/..)
  source "$parent_dir/$path"
}

validate_dirname() {
  local dir=$1

  dir=$(absolute_path "$dir") || return 1

  [[
    -d $dir         &&
    $dir == /*/*
  ]]
}
