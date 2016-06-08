#!/usr/bin/env bash
# Functions for string testing and manipulation

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="${PWD}"

source "${_lib_dir}/core.sh"

core.blank? _string_loaded || return 0
# shellcheck disable=SC2034
declare -r _string_loaded="true"

str.split() {
  local array

  eval "IFS=\"$2\" read -ra array <<< \"\$$1\""
  cat <<< "${array[@]}"
}

core.alias_function str.blank?  core.blank?
core.alias_function str.eql?    core.eql?
str.exit_if_blank? ()  { ! str.blank? 1     || exit "${2:-0}" ;}
