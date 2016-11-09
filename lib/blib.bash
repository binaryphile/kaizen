[[ -n ${_blib:-} ]] && return
readonly _blib=loaded

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
  echo "$result${filename:+/}$filename"
}

chkconfig()           { command -p chkconfig "$@"           ;}
contains()            { [[ ${2:-} == *${1:-}* ]]            ;}
current_user_group()  { groups | awk '{print $1}'           ;}
def_ary()             { IFS=$'\n' read -rd "" -a "$1" ||:   ;}
define()              { read -rd "" "$1" ||:                ;}
dirname()             { [[ $1 == */* ]] && echo "${1%/?*}"  || echo . ;}
echo()                { printf "%s\n" "$*"                  ;}
echoerr()             { cat <<<"$*" 1>&2                    ;}
ends_with()           { [[ ${2:-} == *$1 ]]                 ;}
extension()           { echo "${1#*.}"                      ;}
files_match()         { cmp -s "$1" "$2"                    ;}
groupdel()            { command -p groupdel "$@"            ;}
has_any()             { (( $# ))                            ;}
has_fewer_than()      { (( ($# - 1) < $1 ))                 ;}
has_more_than()       { (( ($# - 1) > $1 ))                 ;}
has_none()            { ! (( $# ))                          ;}
id()                  { command -p id "$@"                  ;}

initialize_blib() {
  # shellcheck disable=SC2034
  printf -v done_message "\nDone.\n"

  cp="cp -r --"                 # shellcheck disable=SC2034
  install="install -bm 664 --"  # shellcheck disable=SC2034
  ln="resolve_ln -sfT --"       # shellcheck disable=SC2034
  mkdir="mkdir -p --"           # shellcheck disable=SC2034
  mv="mv --"                    # shellcheck disable=SC2034
  nix_install="nix-env -ibA"    # shellcheck disable=SC2034
  rm="rm -rf --"                # shellcheck disable=SC2034

  sandbox_environment
}

instantiate() {
  local _blib_par_num_params=$1; shift
  local -A _blib_par_kw_hash
  local -A _blib_par_result
  local -a _blib_par_args
  local -a _blib_par_declaration=( local )
  local -a _blib_par_params
  local _blib_par_arg
  local _blib_par_found=false
  local _blib_par_hashes
  local _blib_par_i
  local _blib_par_item
  local _blib_par_key
  local _blib_par_kwargs
  local _blib_par_name
  local _blib_par_param
  local _blib_par_value

  _blib_par_params=( "${@:1:$_blib_par_num_params}" )
  shift "$_blib_par_num_params"
  for _blib_par_param in "${_blib_par_params[@]}"; do
    _blib_par_result[$_blib_par_param]=""
  done
  _blib_par_args=( "$@" )
  for _blib_par_i in "${!_blib_par_args[@]}"; do
    _blib_par_arg=${_blib_par_args[$_blib_par_i]}
    { starts_with : "$_blib_par_arg" && { contains "=" "$_blib_par_arg" || is_hash "${_blib_par_arg:1}" ;} ;} && {
      _blib_par_found=true
      break
    }
  done
  is_same_as true "$_blib_par_found" && {
    _blib_par_kwargs=( "${_blib_par_args[@]:$_blib_par_i}" )
    _blib_par_args=( "${_blib_par_args[@]:0:$_blib_par_i}" )
  }
  _blib_par_found=false
  for _blib_par_i in "${!_blib_par_kwargs[@]}"; do
    _blib_par_arg="${_blib_par_kwargs[$_blib_par_i]:-}"
    ! is_given "$_blib_par_arg" && continue
    is_hash "${_blib_par_arg:1}" && {
      _blib_par_found=true
      break
    }
  done
  is_same_as true "$_blib_par_found" && {
    _blib_par_hashes=( "${_blib_par_kwargs[@]:$_blib_par_i}" )
    _blib_par_kwargs=( "${_blib_par_kwargs[@]:0:$_blib_par_i}" )
  }
  set -- "${_blib_par_params[@]}"
  for _blib_par_item in "${_blib_par_args[@]:-}"; do
    ! is_given "$_blib_par_item" && continue
    _blib_par_result[$1]=$_blib_par_item
    shift
  done
  for _blib_par_item in "${_blib_par_kwargs[@]:-}"; do
    ! is_given "$_blib_par_item" && continue
    _blib_par_name=${_blib_par_item:1}
    _blib_par_name=${_blib_par_name%=*}
    _blib_par_value=${_blib_par_item##*=}
    _blib_par_kw_hash[$_blib_par_name]=$_blib_par_value
  done
  for _blib_par_key in "$@"; do
    is_given "${_blib_par_kw_hash[$_blib_par_key]:-}" && {
      _blib_par_result[$_blib_par_key]=${_blib_par_kw_hash[$_blib_par_key]}
      continue
    }
    for _blib_par_name in "${_blib_par_hashes[@]:-}"; do
      ! is_given "$_blib_par_name" && continue
      local -n _blib_par_hash=${_blib_par_name:1}
      is_given "${_blib_par_hash[$_blib_par_key]}" && {
        _blib_par_result[$_blib_par_key]=${_blib_par_hash[$_blib_par_key]}
        break
      }
    done
  done
  for _blib_par_key in "${!_blib_par_result[@]}"; do
    _blib_par_declaration+=( "$(printf "%q=%q" "$_blib_par_key" "${_blib_par_result[$_blib_par_key]}")" )
  done
  echo "${_blib_par_declaration[*]}"
}

is_directory()          { [[ -d "$1" ]]                         ;}
is_executable()         { [[ -x "$1" ]]                         ;}
is_executable_file()    { is_file "$1" && is_executable "$1"    ;}
is_file()               { [[ -f "$1" ]]                         ;}
is_function()           { [[ $(type -t "$1") == "function" ]]   ;}
is_given()              { [[ -n "${1:-}" ]]                     ;}
is_group()              { grep -q "$1" /etc/group 2>/dev/null   ;}
is_hash ()              { [[ $(declare -p "$1" 2>/dev/null) == "declare -"[An]* ]] ;}
is_mounted()            { is_on_darwin && { diskutil info "$1" >/dev/null; return ;};  mount | grep -q "$1" ;}
is_nonexecutable_file() { is_file "$1" && ! is_executable "$1"  ;}
is_on_darwin()          { [[ $OSTYPE == darwin* ]]              ;}
is_on_linux()           { [[ $OSTYPE == linux* ]]               ;}
is_on_redhat()          { is_file "/etc/redhat-release" || is_file "/etc/centos-release" ;}
is_owned_by()           { [[ $(owner "$2") == "$1" ]]           ;}
is_same_as()            { [[ $1 == "$2" ]]                      ;}
is_service()            { chkconfig "$@"                        ;}
is_user()               { id "$1" >/dev/null 2>&1               ;}
mode()                  { find "$1" -prune -printf "%m\n" 2>/dev/null   ;}
owner()                 { ls -ld "$1" | awk '{print $3}'        ;}

quietly() {
  #shellcheck disable=SC2154
  is_given  "${debug:-}"  && { "$@"; return ;}
  ! is_given "${silent:-}" && printf .
  "$@" >/dev/null 2>&1
}

remotely() {
  local command=${*:-$(</dev/stdin)}

  # shellcheck disable=SC2154
  is_given "${debug:-}" && printf "\n%s: " "$target"
  command=$(printf "%sumask 002; %s" "${debug:+export debug=true; }" "$command")
  command=$(printf "bash -c %q" "$command")
  # shellcheck disable=SC2154,SC2029
  ssh -Aqt "$target" "$command"
}

resolve_ln() { $(type -p gln ln | head -1) "$@" ;}

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

succeed()   { "$@" ||:                  ;}
sudo()      { command -p sudo "$@"      ;}
timestamp() { date +%s                  ;}

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
