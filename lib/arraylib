#!/usr/bin/env bash

# https://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value#answer-8574392
ary_contains () {
  local elem
  for elem in "${@:2}"; do
    if [[ "${elem}" == "$1" ]]; then
      return 0
    fi
  done
  return 1
}

ary_find () {
  local i
  local item
  local array

  item="$1"
  shift
  array=( "$@" )
  for i in "${!array[@]}"; do
    if [[ "${array[${i}]}" == "${item}" ]]; then
      echo "${i}"
      return 0
    fi
  done
  return 1
}

# https://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array#answer-17841619
ary_join () {
  local delim

  delim="$1"
  shift
  echo -n "$1"
  shift
  printf "%s" "${@/#/${delim}}"
}

ary_remove () {
  local i
  local item
  local result

  item="$1"
  shift
  result=( )
  for i in "$@"; do
    [[ "${i}" == "${item}" ]] || result+=( "${i}" )
  done
  echo "${result[@]}"
}

ary_slice () {
  local first
  local last
  local array
  local result

  first="$1"
  shift
  last="$1"
  shift
  array=( "$@" )
  echo "${array[@]:${first}:$((${last}-${first}+1))}"
}
