_is_keyword_arg() { deprecate; starts_with : "$1" and contains '=' "$1" ;}

copya() {
  deprecate
  local -n _ref1=$1
  # shellcheck disable=SC2034
  local -n _ref2=$2
  local _i

  for _i in "${!_ref1[@]}"; do
    printf -v _ref2[$_i] '%s' "${_ref1[$_i]}"
  done
}

chkconfig()           { deprecate; command chkconfig "$@"              ;}
contains()            { deprecate; [[ ${2:-} == *${1:-}* ]]            ;}
current_user_group()  { deprecate; groups | awk '{print $1}'           ;}
def_ary()             { putserr 'def_ary is deprecated, please use geta instead.'; IFS=$'\n' read -rd "" -a "$1" ||:   ;}
define()              { putserr 'define is deprecated, please use defs or gets instead.'; read -rd '' "$1" ||: ;}
deprecate()           { putserr "$(printf '%s is deprecated' "${FUNCNAME[1]}")" ;}
ends_with()           { deprecate; [[ ${2:-} == *$1 ]]                 ;}
extension()           { deprecate; puts "${1#*.}"                      ;}
files_match()         { deprecate; cmp -s "$1" "$2"                    ;}
gets()                { deprecate; read -rd '' "$1" ||:                ;}
groupdel()            { deprecate; command -p groupdel "$@"            ;}
has_any()             { deprecate; (( $# ))                            ;}
has_fewer_than()      { deprecate; (( ($# - 1) < $1 ))                 ;}
has_more_than()       { deprecate; (( ($# - 1) > $1 ))                 ;}
has_none()            { deprecate; ! (( $# ))                          ;}
id()                  { deprecate; command -p id "$@"                  ;}

includes()            {
  deprecate
  local term=$1; shift
  local item

  for item in "$@"; do
    [[ $term == "$item" ]] && return
  done
  return 1
}

instantiate() {
  deprecate
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
  is_set _kzn_kwargs && {
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

is_executable()         { deprecate; [[ -x "$1" ]]                         ;}
is_executable_file()    { deprecate; is_file "$1" && is_executable "$1"    ;}
is_function()           { deprecate; [[ $(type -t "$1") == "function" ]]   ;}
is_group()              { deprecate; grep -q "$1" /etc/group 2>/dev/null   ;}
is_hash ()              { deprecate; is_symbol "$1" && [[ $(declare -p "${1:1}" 2>/dev/null) == 'declare -'[An]* ]] ;}
is_mounted()            { deprecate; is_on_darwin && { diskutil info "$1" >/dev/null; return ;};  mount | grep -q "$1" ;}
is_nonexecutable_file() { deprecate; is_file "$1" && ! is_executable "$1"  ;}
is_on_darwin()          { deprecate; [[ $OSTYPE == darwin* ]]              ;}
is_on_linux()           { deprecate; [[ $OSTYPE == linux* ]]               ;}
is_on_redhat()          { deprecate; is_file /etc/redhat-release || is_file /etc/centos-release ;}
is_owned_by()           { deprecate; [[ $(owner "$2") == "$1" ]]           ;}
is_service()            { deprecate; chkconfig "$@"                        ;}
is_symbol()             { deprecate; starts_with : "$1"                    ;}
is_user()               { deprecate; id "$1" >/dev/null 2>&1               ;}
mode()                  { deprecate; find "$1" -prune -printf "%m\n" 2>/dev/null   ;}
owner()                 { deprecate; is_on_darwin && { stat -f '%Su' "$1"; return ;}; stat -c '%U' "$1" ;}

quietly() {
  deprecate
  #shellcheck disable=SC2154
  is_given  "${debug:-}"  && { "$@"; return ;}
  ! is_given "${silent:-}" && printf .
  "$@" >/dev/null 2>&1
}

readlink() { deprecate; is_on_darwin && { greadlink "$@"; return ;}; command readlink "$@" ;}

remotely() {
  deprecate
  local command=${*:-$(</dev/stdin)}

  # shellcheck disable=SC2154
  is_given "${debug:-}" && printf "\n%s: " "$target"
  command=$(printf "%sumask 002; %s" "${debug:+export debug=true; }" "$command")
  command=$(printf "bash -c %q" "$command")
  # shellcheck disable=SC2154,SC2029
  ssh -Aqt "$target" "$command"
}

runas() {
  deprecate
  local user=$1; shift
  local command=${*:-$(</dev/stdin)}

  sudo -u "$user" BASH_ENV=~"$user"/.bashrc bash -c "unset -v BASH_ENV; umask 002; ${debug:+export debug=true; }$command"
}

silently() {
  deprecate
  #shellcheck disable=SC2154
  is_given  "${debug:-}" && { "$@"; return ;}
  "$@" >/dev/null 2>&1
}

split_str() {
  deprecate
  local _blib_spl_delimiter=$1
  local _blib_spl_string=$2
  local -n _blib_spl_ref=$3

  # shellcheck disable=SC2034
  IFS="$_blib_spl_delimiter" read -ra _blib_spl_ref <<<"$_blib_spl_string" ||:
}

succeed()   { deprecate; "$@" ||:              ;}
sudo()      { deprecate; command -p sudo "$@"  ;}
timestamp() { deprecate; date +%s              ;}
to_lower()  { deprecate; puts "${1,,}"         ;}

user_agrees() {
  deprecate
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

useradd()   { deprecate; command -p useradd "$@"   ;}

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

sandbox_environment() {
  umask 002
}

