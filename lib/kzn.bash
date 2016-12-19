[[ -n ${_kzn:-} ]] && return
readonly _kzn=loaded

_is_keyword_arg() { starts_with : "$1" and contains '=' "$1" ;}

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

basename()            { puts "${1##*/}"                     ;}

copya() {
  local -n _kzn_ref1=$1
  # shellcheck disable=SC2034
  local -n _kzn_ref2=$2
  local _i

  for _i in "${!_kzn_ref1[@]}"; do
    printf -v _kzn_ref2[$_i] '%s' "${_kzn_ref1[$_i]}"
  done
}

chkconfig()           { command chkconfig "$@"              ;}
contains()            { [[ ${2:-} == *${1:-}* ]]            ;}
current_user_group()  { groups | awk '{print $1}'           ;}
def_ary()             { putserr 'def_ary is deprecated, please use geta instead.'; IFS=$'\n' read -rd "" -a "$1" ||:   ;}

defa()    { geta "$1"; stripa "$1" ;}
define()  { putserr 'define is deprecated, please use defs or gets instead.'; read -rd '' "$1" ||: ;}

defs() {
  local -a _kzn_result
  local IFS

  defa _kzn_result
  IFS=$'\n'
  printf -v "$1" '%s' "${_kzn_result[*]}"
}

# shellcheck disable=SC2015
dirname()             { [[ $1 == */* ]] && puts "${1%/?*}"  || puts . ;}
ends_with()           { [[ ${2:-} == *$1 ]]                 ;}
errexit()             { putserr "$1"; exit "${2:-1}"        ;}
extension()           { puts "${1#*.}"                      ;}
files_match()         { cmp -s "$1" "$2"                    ;}

geta() {
  while IFS= read -r; do
    eval "$(printf '%s+=( %q )' "$1" "$REPLY")"
  done
}

gets()                { read -rd '' "$1" ||:                ;}
groupdel()            { command -p groupdel "$@"            ;}
has_any()             { (( $# ))                            ;}
has_fewer_than()      { (( ($# - 1) < $1 ))                 ;}
has_more_than()       { (( ($# - 1) > $1 ))                 ;}
has_none()            { ! (( $# ))                          ;}
id()                  { command -p id "$@"                  ;}

includes()            {
  local term=$1; shift
  local item

  for item in "$@"; do
    [[ $term == "$item" ]] && return
  done
  return 1
}

initialize_kzn() {
  # shellcheck disable=SC2034
  printf -v done_message "\nDone.\n"

  cp="cp -r --"                 # shellcheck disable=SC2034
  install="install -bm 664 --"  # shellcheck disable=SC2034
  mkdir="mkdir -p --"           # shellcheck disable=SC2034
  mv="mv --"                    # shellcheck disable=SC2034
  rm="rm -rf --"                # shellcheck disable=SC2034
  is_on_darwin && {
    ln=gln                      # shellcheck disable=SC2034
  }
  is_on_linux && {
    ln=ln
  }
  ln="$ln -sfT --"              # shellcheck disable=SC2034

  sandbox_environment
}

instantiate() {
  local _kzn_num_params=$1; shift
  local -A _kzn_kw_hash
  local -A _kzn_result
  local -A _kzn_result_hashes
  local -a _kzn_args
  local -a _kzn_declaration
  local -a _kzn_output
  local -a _kzn_params
  local _kzn_arg
  local _kzn_found=false
  local _kzn_hashes
  local _kzn_i
  local _kzn_item
  local _kzn_key
  local _kzn_kwargs
  local _kzn_name
  local _kzn_value
  local IFS

  _kzn_params=( "${@:1:$_kzn_num_params}" )
  shift "$_kzn_num_params"
  _kzn_args=( "$@" )
  for _kzn_i in "${!_kzn_args[@]}"; do
    _kzn_arg=${_kzn_args[$_kzn_i]}
    { _is_keyword_arg "$_kzn_arg" || is_hash "$_kzn_arg" ;} && {
      _kzn_found=true
      break
    }
  done
  is_same_as true "$_kzn_found" && {
    _kzn_kwargs=( "${_kzn_args[@]:$_kzn_i}" )
    _kzn_args=( "${_kzn_args[@]:0:$_kzn_i}" )
  }
  _kzn_found=false
  is_set :_kzn_kwargs && {
    for _kzn_i in "${!_kzn_kwargs[@]}"; do
      is_hash "${_kzn_kwargs[$_kzn_i]}" && {
        _kzn_found=true
        break
      }
    done
  }
  is_same_as true "$_kzn_found" && {
    _kzn_hashes=( "${_kzn_kwargs[@]:$_kzn_i}" )
    _kzn_kwargs=( "${_kzn_kwargs[@]:0:$_kzn_i}" )
  }
  set -- "${_kzn_params[@]}"
  is_given "${!_kzn_args[*]}" && {
    for _kzn_item in "${_kzn_args[@]}"; do
      is_symbol "$1" && {
        _kzn_i=$(declare -p "$_kzn_item")
        _kzn_result_hashes[${1:1}]=${_kzn_i#declare -A*=}
        shift
        continue
      }
      _kzn_result[$1]=$_kzn_item
      shift
    done
  }
  is_given "${!_kzn_kwargs[*]}" && {
    for _kzn_item in "${_kzn_kwargs[@]}"; do
      _kzn_name=${_kzn_item:1}
      _kzn_name=${_kzn_name%=*}
      _kzn_value=${_kzn_item##*=}
      _kzn_kw_hash[$_kzn_name]=$_kzn_value
    done
  }
  for _kzn_key in "$@"; do
    includes "$_kzn_key" "${!_kzn_kw_hash[@]}" && {
      _kzn_result[$_kzn_key]=${_kzn_kw_hash[$_kzn_key]}
      continue
    }
    is_given "${!_kzn_hashes[*]}" && {
      for _kzn_name in "${_kzn_hashes[@]}"; do
        local -n _kzn_hash=${_kzn_name:1}
        includes "$_kzn_key" "${!_kzn_hash[@]}" && {
          _kzn_result[$_kzn_key]=${_kzn_hash[$_kzn_key]}
          break
        }
      done
    }
  done
  is_given "${!_kzn_result[*]}" && {
    for _kzn_key in "${!_kzn_result[@]}"; do
      _kzn_declaration+=( "$(printf "%q=%q" "$_kzn_key" "${_kzn_result[$_kzn_key]}")" )
    done
  }
  is_given "${!_kzn_declaration[*]}" && {
    _kzn_declaration=( declare "${_kzn_declaration[@]}" )
    _kzn_output=( "${_kzn_declaration[*]}" )
  }
  is_given "${!_kzn_result_hashes[*]}" && {
    for _kzn_key in "${!_kzn_result_hashes[@]}"; do
      _kzn_output+=( "$(printf 'declare -A %s=%s' "$_kzn_key" "${_kzn_result_hashes[$_kzn_key]}")" )
    done
  }
  IFS=';'
  puts "${_kzn_output[*]}"
}

is_directory()          { [[ -d "$1" ]]                         ;}
is_executable()         { [[ -x "$1" ]]                         ;}
is_executable_file()    { is_file "$1" && is_executable "$1"    ;}
is_file()               { [[ -f "$1" ]]                         ;}
is_function()           { [[ $(type -t "$1") == "function" ]]   ;}
is_given()              { [[ -n "${1:-}" ]]                     ;}
is_group()              { grep -q "$1" /etc/group 2>/dev/null   ;}
is_hash ()              { is_symbol "$1" && [[ $(declare -p "${1:1}" 2>/dev/null) == 'declare -'[An]* ]] ;}
is_mounted()            { is_on_darwin && { diskutil info "$1" >/dev/null; return ;};  mount | grep -q "$1" ;}
is_nonexecutable_file() { is_file "$1" && ! is_executable "$1"  ;}
is_on_darwin()          { [[ $OSTYPE == darwin* ]]              ;}
is_on_linux()           { [[ $OSTYPE == linux* ]]               ;}
is_on_redhat()          { is_file /etc/redhat-release || is_file /etc/centos-release ;}
is_owned_by()           { [[ $(owner "$2") == "$1" ]]           ;}
is_same_as()            { [[ $1 == "$2" ]]                      ;}
is_service()            { chkconfig "$@"                        ;}
is_set()                { is_symbol "$1" && declare -p "${1:1}" >/dev/null 2>&1 ;}
is_symbol()             { starts_with : "$1"                    ;}
is_symlink()            { [[ -h "$1" ]]                         ;}
is_user()               { id "$1" >/dev/null 2>&1               ;}
mode()                  { find "$1" -prune -printf "%m\n" 2>/dev/null   ;}
owner()                 { is_on_darwin && { stat -f '%Su' "$1"; return ;}; stat -c '%U' "$1" ;}

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

  _options() {
    case $1 in
      @)
        puts a
        ;;
      %)
        puts A
        ;;
    esac
  }

  for _i in "${!_parameters[@]}"; do
    _argument=${_arguments[$_i]}
    _parameter=${_parameters[$_i]}
    _type=${_parameter:0:1}
    case $_type in
      '@' | '%' | ':' )
        _parameter=${_parameter:1}
        if starts_with [ "$_argument"; then
          _declaration=$(printf 'declare -%s %s=%s(%s)%s' "$(_options "$_type")" "$_parameter" \' "$_argument" \')
        else
          _declaration=$(declare -p "$_argument")
          _declaration=${_declaration/$_argument/$_parameter}
        fi
        _result+=( "$_declaration" )
        ;;
      * )
        _result+=( "$(printf 'declare %s=%s' "$_parameter" "$_argument")" )
        ;;
    esac
  done
  IFS=';'
  puts "${_result[*]}"
}

puts()                  { printf "%s\n" "$*"  ;}
putserr()               { puts "$*" >&2       ;}

quietly() {
  #shellcheck disable=SC2154
  is_given  "${debug:-}"  && { "$@"; return ;}
  ! is_given "${silent:-}" && printf .
  "$@" >/dev/null 2>&1
}

readlink() { is_on_darwin && { greadlink "$@"; return ;}; command readlink "$@" ;}

remotely() {
  local command=${*:-$(</dev/stdin)}

  # shellcheck disable=SC2154
  is_given "${debug:-}" && printf "\n%s: " "$target"
  command=$(printf "%sumask 002; %s" "${debug:+export debug=true; }" "$command")
  command=$(printf "bash -c %q" "$command")
  # shellcheck disable=SC2154,SC2029
  ssh -Aqt "$target" "$command"
}

runas() {
  local user=$1; shift
  local command=${*:-$(</dev/stdin)}

  sudo -u "$user" BASH_ENV=~"$user"/.bashrc bash -c "unset -v BASH_ENV; umask 002; ${debug:+export debug=true; }$command"
}

sandbox_environment() {
  umask 002
}

silently() {
  #shellcheck disable=SC2154
  is_given  "${debug:-}" && { "$@"; return ;}
  "$@" >/dev/null 2>&1
}

split_str() {
  local _blib_spl_delimiter=$1
  local _blib_spl_string=$2
  local -n _blib_spl_ref=$3

  # shellcheck disable=SC2034
  IFS="$_blib_spl_delimiter" read -ra _blib_spl_ref <<<"$_blib_spl_string" ||:
}

starts_with() { [[ ${2:-} == "$1"* ]] ;}

strict_mode() {
  case $1 in
    on  )
      set -o errexit
      set -o pipefail
      set -o nounset
      ;;
    off )
      set +o errexit
      set +o pipefail
      set +o nounset
      ;;
  esac
}

stripa() {
  local -n _kzn_ref=$1
  local _kzn_i
  local _kzn_leading_whitespace
  local _kzn_len

  _kzn_leading_whitespace=${_kzn_ref[0]%%[^[:space:]]*}
  _kzn_len=${#_kzn_leading_whitespace}
  for _kzn_i in "${!_kzn_ref[@]}"; do
    printf -v _kzn_ref[$_kzn_i] '%s' "${_kzn_ref[$_kzn_i]:$_kzn_len}"
  done
}

succeed()   { "$@" ||:              ;}
sudo()      { command -p sudo "$@"  ;}
timestamp() { date +%s              ;}
to_lower()  { puts "${1,,}"         ;}

user_agrees() {
  local answer
  local prompt=${*:-Agree? [Y/n]}
  local expression="\[(.+)/(.+)\]"

  [[ $prompt =~ $expression ]] && {
    yes=${BASH_REMATCH[1]}
    no=${BASH_REMATCH[2]}
  }
  [[ $yes == [[:upper:]]* ]] && default=$yes || default=$no
  yes=${yes,,}
  no=${no,,}

  read -ep "$prompt " answer
  answer=${answer:-$default}
  answer=${answer,,}
  starts_with "$yes" "$answer"
}

useradd()   { command -p useradd "$@"   ;}
