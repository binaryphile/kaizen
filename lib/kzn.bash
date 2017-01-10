[[ -n ${_kzn:-} ]] && return
readonly _kzn=loaded

source import.bash
source sorta.bash

_required_imports=(
  basename
  defa
  dirname
  geta
  is_directory
  is_executable
  is_file
  puts
  putserr
  stripa
)

absolute_path() {
  eval "$(passed '( path )' "$@")"
  local filename

  unset -v CDPATH
  is_file path && {
    filename=$(basename path)
    path=$(dirname path)
  }
  is_directory path || return 1
  result=$( ( cd "$path"; pwd ) ) || return
  puts "$result${filename:+/}${filename:-}"
}

basename() {
  eval "$(passed '( path )' "$@")"

  puts "${path##*/}"
}

defa() { geta "$1"; stripa "$1" ;}

defs() {
  local -a _results
  local IFS

  defa _results
  IFS=$'\n'
  printf -v "$1" '%s' "${_results[*]}"
}

dirname() {
  eval "$(passed '( path )' "$@")"
  if [[ $path == */* ]]; then
    puts "${path%/?*}"
  else
    puts .
  fi
}

errexit() {
  eval "$(passed '( message return_code=1)' "$@")"

  putserr message
  exit "$return_code"
}

geta() {
  while IFS= read -r; do
    eval "$(printf '%s+=( %q )' "$1" "$REPLY")"
  done
}

has_length() {
  eval "$(passed '( length @array )' "$@")"

  (( length == ${#array} ))
}

is_directory() {
  eval "$(passed '( path )' "$@")"

  [[ -d $path ]]
}

is_executable() {
  eval "$(passed '( path )' "$@")"

  [[ -x $path ]]
}

is_executable_file() {
  eval "$(passed '( path )' "$@")"

  is_file path && is_executable path
}

is_file() {
  eval "$(passed '( path )' "$@")"

  [[ -f $path ]]
}

is_given() {
  eval "$(passed '( value )' "$@")"

  declare -p "$1" >/dev/null 2>&1 && [[ -n $value ]]
}

is_nonexecutable_file() {
  eval "$(passed '( path )' "$@")"

  is_file path && ! is_executable path
}

is_same_as() {
  eval "$(passed '( string1 string2 )' "$@")"

  [[ $string1 == "$string2" ]]
}

is_set() { declare -p "$1" >/dev/null 2>&1 ;}

is_symlink() {
  eval "$(passed '( path )' "$@")"

  [[ -h $path ]]
}

joina() {
  eval "$(passed '( delimiter @array )' "$@")"
  local IFS
  local result

  set -- "${array[@]}"
  IFS=';'
  printf '%s\n' "${array[*]}"
}

puts() {
  eval "$(passed '( message )' "$@")"

  printf '%s\n' "$message"
}

putserr() {
  eval "$(passed '( message )' "$@")"

  puts message >&2
}

splits() {
  eval "$(passed '( delimiter string )' "$@")"
  local -a results
  local IFS

  IFS="$delimiter"
  set -- $string
  results=( "$@" )
  pass results
}

starts_with() {
  eval "$(passed '( prefix string )' "$@")"

  [[ $string == "$prefix"* ]]
}

strict_mode() {
  eval "$(passed '( status )' "$@")"

  case $status in
    on )
      set -o errexit
      set -o nounset
      set -o pipefail
      ;;
    off )
      set +o errexit
      set +o nounset
      set +o pipefail
      ;;
  esac
}

stripa() {
  eval "$(passed '( "&_ref" )' "$@")"
  local _i
  local _leading_whitespace
  local _len

  _leading_whitespace=${_ref[0]%%[^[:space:]]*}
  _len=${#_leading_whitespace}
  for _i in "${!_ref[@]}"; do
    printf -v _ref[$_i] '%s' "${_ref[$_i]:$_len}"
  done
}

to_lower() {
  eval "$(passed '( string )' "$@")"

  puts "${string,,}"
}

to_upper() {
  eval "$(passed '( string )' "$@")"

  puts "${string^^}"
}
