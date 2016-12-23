[[ -n ${_kzn:-} ]] && return
readonly _kzn=loaded

absolute_path() {
  local target=$1
  local filename

  unset -v CDPATH

  is_file "$target" && {
    filename=$(basename "$target")
    target=$(dirname "$target")
  }
  is_directory "$target" || return 1
  result=$( ( cd "$target"; pwd ) ) || return
  puts "$result${filename:+/}${filename:-}"
}

basename()  { puts "${1##*/}"         ;}
defa()      { geta "$1"; stripa "$1"  ;}

defs() {
  local -a _result
  local IFS

  defa _result
  IFS=$'\n'
  printf -v "$1" '%s' "${_result[*]}"
}

# shellcheck disable=SC2015
dirname() { [[ $1 == */* ]] && puts "${1%/?*}" || puts . ;}
errexit() { putserr "$1"; exit "${2:-1}" ;}

geta() {
  while IFS= read -r; do
    eval "$(printf '%s+=( %q )' "$1" "$REPLY")"
  done
}

is_directory()          { [[ -d "$1" ]]                   ;}
is_file()               { [[ -f "$1" ]]                   ;}
is_given()              { [[ -n "${1:-}" ]]               ;}
is_same_as()            { [[ $1 == "$2" ]]                ;}
is_set()                { declare -p "$1" >/dev/null 2>&1 ;}
is_symlink()            { [[ -h "$1" ]]                   ;}

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
      '^')
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
      '^' )
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
}

puts()        { printf "%s\n" "$*"    ;}
putserr()     { puts "$@" >&2         ;}
starts_with() { [[ ${2:-} == "$1"* ]] ;}

strict_mode() {
  case $1 in
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
  local _params=( ^_ref )
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
