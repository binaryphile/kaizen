[[ -n ${_shpec_helper:-} ]] && return
readonly _shpec_helper=loaded

source import.bash

eval "$(importa kzn '( absolute_path dirname )')"

_required_imports=(
  absolute_path
  dirname
  is_file
  is_directory
  puts
  validate_dirname
)

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
  eval "$(passed '( path )' "$@")"

  path=$(absolute_path "$path") || return 1
  [[
    -d $path        &&
    $path == /*/*
  ]]
}
