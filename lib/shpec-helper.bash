[[ -n ${_shpec_helper:-} ]] && return
readonly _shpec_helper=loaded

source import.bash

eval "$(importa kzn '( absolute_path dirname putserr )')"

_required_imports=(
  absolute_path
  dirname
  is_file
  is_directory
  puts
  putserr
  shpec_cleanup
  validate_dirname
)

cleanup() {
  putserr "DEPRECATION: cleanup has been changed to shpec_cleanup. Please change your code."
  shpec_cleanup "$@"
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

shpec_cleanup() {
  eval "$(passed '( path )' "$@")"

  validate_dirname path || return
  $rm "$path"
}

shpec_source() {
  eval "$(passed '( path )' "$@")"
  local parent_dir

  parent_dir=$(absolute_path "$(dirname "$BASH_SOURCE")"/..)
  source "$parent_dir/$path"
}

stop_on_error() {
  local toggle=${1:-}

  if [[ -n $toggle ]]; then
    set +o errexit
    set +o nounset
    set +o pipefail
    return
  fi
  if [[ $stop_on_error == 'true' ]]; then
    set -o errexit
    set -o nounset
    set -o pipefail
  fi
}

validate_dirname() {
  eval "$(passed '( path )' "$@")"

  path=$(absolute_path "$path") || return 1
  [[
    -d $path        &&
    $path == /*/*
  ]]
}
