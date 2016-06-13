#!/usr/bin/env bash
# Functions for string testing and manipulation

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="$PWD"

source "$_lib_dir"/core.sh

_str.blank? _string_loaded || return 0
# shellcheck disable=SC2034
declare -r _string_loaded="true"

# shellcheck disable=SC2034
read -d "" -a _aliases <<EOS
blank?
eql?
EOS

_core.alias_core str _aliases
unset _aliases

str.split() {
  local array

  IFS="$2" read -ra array <<< "$(_sh.value "$1")"
  cat <<< "${array[@]}"
}

str.exit_if_blank? ()  { ! str.blank? "$1" || exit "${2:-0}" ;}
