#!/usr/bin/env bash
# Functions for array manipulation

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="$PWD"

source "$_lib_dir"/core.sh

_String.blank? _Array_loaded || return 0
# shellcheck disable=SC2034
declare -r _Array_loaded="true"

# shellcheck disable=SC2034
read -d "" -a _aliases <<EOS
use
asc_use
EOS

_core.alias_core Array _aliases
unset -v _aliases

# https://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value#answer-8574392
Array.include? () {
  local elem
  local array

  array=( $(_sh.value "$1") )
  for elem in "${array[@]}"; do
    if [[ $elem == "$2" ]]; then
      return 0
    fi
  done
  return 1
}

Array.index() {
  local array
  local i
  local item="$2"

  array=( $( _sh.value "$1") )
  for i in "${!array[@]}"; do
    if [[ ${array[${i}]} == "$item" ]]; then
      printf "%s" "$i"
      return 0
    fi
  done
  return 1
}

# https://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array#answer-17841619
Array.join() {
  local delim="$2"

  # shellcheck disable=SC2046
  set -- $(_sh.value "$1")
  printf "%s" "$1"
  shift
  printf "%s" "${@/#/$delim}"
}

Array.new() {
  local method
  local methods

  # shellcheck disable=SC2034
  read -d "" -a methods <<EOS
include?
index
join
remove
slice
EOS

  for method in "${methods[@]}"; do
    _core.alias_method "$1" "$method" "Array"
  done
}

Array.remove() {
  local i
  local item
  local result

  item="$2"
  # shellcheck disable=SC2046
  set -- $(_sh.value "$1")
  result=( )
  for i in "$@"; do
    [[ $i == "$item" ]] || result+=( "$i" )
  done
  echo "${result[@]}"
}

Array.slice() {
  local first=$2
  local last=$3
  local array

  eval "local array=(\"\${$1[@]}\")"

  cat <<< "${array[@]:${first}:$((last-first+1))}"
}
