#!/usr/bin/env bash
# Functions for array manipulation

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="${PWD}"

source "$_lib_dir"/_core.sh

_core.blank? _array_loaded || return 0
# shellcheck disable=SC2034
declare -r _array_loaded="true"

# https://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value#answer-8574392
ary.include? () {
  local elem
  for elem in "${@:2}"; do
    if [[ $elem == "$1" ]]; then
      return 0
    fi
  done
  return 1
}

ary.index() {
  local i
  local item
  local array

  item="$1"
  shift
  array=( "$@" )
  for i in "${!array[@]}"; do
    if [[ ${array[${i}]} == "$item" ]]; then
      printf "%s" "$i"
      return 0
    fi
  done
  return 1
}

# https://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array#answer-17841619
ary.join() {
  local delim

  delim="$1"
  shift
  echo -n "$1"
  shift
  printf "%s" "${@/#/$delim}"
}

ary.new() {
  _core.deref "$2"
  local "$1" && _core.upvar "$1" "$2"
}

ary.remove() {
  local i
  local item
  local result

  item="$1"
  shift
  result=( )
  for i in "$@"; do
    [[ $i == "$item" ]] || result+=( "$i" )
  done
  echo "${result[@]}"
}

ary.slice() {
  local first=$2
  local last=$3
  local array

  eval "local array=(\"\${$1[@]}\")"

  cat <<< "${array[@]:${first}:$((last-first+1))}"
}
