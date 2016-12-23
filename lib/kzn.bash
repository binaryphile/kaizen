[[ -n ${_kzn:-} ]] && return
readonly _kzn=loaded

absolute_path() {
  local params=( path )
  eval "$(passed params "$@")"
  # shellcheck disable=SC2154
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

assign() {
  local params=( _ref _value )
  eval "$(passed params "$@")"
  # shellcheck disable=SC2154
  _name=${_value%%=*}
  _name=${_name##* }
  printf '%s' "${_value/$_name/$_ref}"
}

basename() {
  local params=( path )
  eval "$(passed params "$@")"
  # shellcheck disable=SC2154
  puts "${path##*/}"
}

defa()      { geta "$1"; stripa "$1"  ;}

defs() {
  local -a _result
  local IFS

  defa _result
  IFS=$'\n'
  printf -v "$1" '%s' "${_result[*]}"
}

# shellcheck disable=SC2015
dirname() {
  local params=( path )
  eval "$(passed params "$@")"
  # shellcheck disable=SC2154
  if [[ $path == */* ]]; then
    puts "${path%/?*}"
  else
    puts .
  fi
}

errexit() {
  local params=( message return_code )
  eval "$(passed params "$@")"
  # shellcheck disable=SC2154
  putserr "$message"; exit "${return_code:-1}"
}

geta() {
  while IFS= read -r; do
    eval "$(printf '%s+=( %q )' "$1" "$REPLY")"
  done
}

is_directory() {
  local params=( path )
  eval "$(passed params "$@")"
  # shellcheck disable=SC2154
  [[ -d $path ]]
}

is_file() {
  local params=( path )
  eval "$(passed params "$@")"
  # shellcheck disable=SC2154
  [[ -f $path ]]
}

is_given() {
  local params=( value )
  eval "$(passed params "$@")"
  [[ -n ${value:-} ]]
}

is_same_as() {
  local params=( string1 string2 )
  eval "$(passed params "$@")"
  # shellcheck disable=SC2154
  [[ $string1 == "$string2" ]]
}

is_set() { declare -p "$1" >/dev/null 2>&1 ;}

is_symlink() {
  local params=( path )
  eval "$(passed params "$@")"
  # shellcheck disable=SC2154
  [[ -h $path ]]
}

passed() {
  local -n _parameters=$1; shift
  local -a _arguments=( "$@" )
  local -a _result
  local IFS
  local _argument
  local _declaration
  local _i
  local _parameter
  local _type

  options() {
    case $1 in
      '@')
        puts a
        ;;
      '%')
        puts A
        ;;
      '&')
        puts n
        ;;
    esac
  }

  for _i in "${!_parameters[@]}"; do
    _argument=${_arguments[$_i]}
    _parameter=${_parameters[$_i]}
    _type=${_parameter:0:1}
    case $_type in
      '@' | '%' )
        _parameter=${_parameter:1}
        if [[ $_argument == '['* ]]; then
          _declaration=$(printf 'declare -%s %s=%s(%s)%s' "$(options "$_type")" "$_parameter" \' "$_argument" \')
        else
          _declaration=$(declare -p "$_argument")
          _declaration=${_declaration/$_argument/$_parameter}
        fi
        _result+=( "$_declaration" )
        ;;
      '&' )
        _parameter=${_parameter:1}
        _result+=( "$(printf 'declare -%s %s="%s"' "$(options "$_type")" "$_parameter" "$_argument")" )
        ;;
      * )
        if declare -p "$_argument" >/dev/null 2>&1; then
          _declaration=$(declare -p "$_argument")
          _declaration=${_declaration/$_argument/$_parameter}
          _result+=( "$_declaration" )
        else
          _result+=( "$(printf 'declare -- %s="%s"' "$_parameter" "$_argument")" )
        fi
        ;;
    esac
  done
  IFS=';'
  puts "${_result[*]}"
  unset -f options
}

puts()        { printf "%s\n" "$*"    ;}
putserr()     { puts "$@" >&2         ;}

starts_with() {
  # shellcheck disable=SC2034
  local params=( prefix string )
  eval "$(passed params "$@")"

  # shellcheck disable=SC2154
  [[ ${string:-} == "$prefix"* ]]
}

strict_mode() {
  # shellcheck disable=SC2034
  local params=( status )
  eval "$(passed params "$@")"

  # shellcheck disable=SC2154
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
  # shellcheck disable=SC2034
  local _params=( '&_ref' )
  eval "$(passed _params "$@")"

  local _i
  local _leading_whitespace
  local _len

  # shellcheck disable=SC2154
  _leading_whitespace=${_ref[0]%%[^[:space:]]*}
  _len=${#_leading_whitespace}
  for _i in "${!_ref[@]}"; do
    printf -v _ref[$_i] '%s' "${_ref[$_i]:$_len}"
  done
}
