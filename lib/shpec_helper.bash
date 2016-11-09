[[ -n $_shpec_helper ]] && return
readonly _shpec_helper=loaded

source blib.bash
initialize_blib

cleanup() {
  validate_dirname "$1" || return
  rm -rf -- "$1"
}

initialize_shpec_helper() {
  local tmp=$HOME/tmp

  umask 002
  rm="rm -rf --"                # shellcheck disable=SC2034
  mkdir="mkdir -p --"           # shellcheck disable=SC2034

  # shellcheck disable=SC2154
  $mkdir "$tmp"
  mktemp="mktemp -qp $tmp"      # shellcheck disable=SC2034
  mktempd="mktemp -qdp $tmp"    # shellcheck disable=SC2034

  unset -v CDPATH
}

make_temp_dir() {
  local base_dir="${1:-"${TMPDIR:-/tmp}"}"

  result=$(mktemp -d "$base_dir/tmpdir.XXXXXX") || return

  echo "$result"
}

make_temp_file() {
  local base_dir="${1:-"${TMPDIR:-/tmp}"}"
  local result

  result=$(mktemp "$base_dir/file.XXXXXX") || return

  echo "$result"
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

_shpec_helper_parent_dir=$(absolute_path "$(dirname "$BASH_SOURCE")"/..)
