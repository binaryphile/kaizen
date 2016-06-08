#!/usr/bin/env bash
# Functions for string testing and manipulation

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="${PWD}"

source "$_lib_dir"/_core.sh

_core.blank? _string_loaded || return 0
# shellcheck disable=SC2034
declare -r _string_loaded="true"

str.split() {
  local array

  IFS=$(_core.value "2") read -ra array <<< "$(_core.value "1")"
  cat <<< "${array[@]}"
}

_core.alias_function str.blank?  _core.blank?
_core.alias_function str.eql?    _core.eql?
str.exit_if_blank? ()  { ! str.blank? "1" || exit "${2:-0}" ;}
