[[ -n ${_shpec_helper:-} ]] && return
readonly _shpec_helper=loaded

source kzn.bash

_shpec_helper_parent_dir=$(absolute_path "$(dirname "$BASH_SOURCE")"/..)

cleanup() {
  validate_dirname "$1" || return
  # shellcheck disable=SC2154
  $rm "$1"
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
  local path=$1

  source "$_shpec_helper_parent_dir/$path"
}

validate_dirname() {
  local dir=$1

  dir=$(absolute_path "$dir") || return 1

  [[
    -d $dir         &&
    $dir == /*/*
  ]]
}
