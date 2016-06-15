#!/usr/bin/env bash
# Functions for string testing and manipulation

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="$PWD"

source "$_lib_dir"/core.sh

_String.blank? _String_loaded || return 0
# shellcheck disable=SC2034
declare -r _String_loaded="true"

# shellcheck disable=SC2034
read -d "" -a _aliases <<EOS
blank?
eql?
EOS

_core.alias_core String _aliases
unset _aliases

String.split() {
  local array

  IFS="$2" read -ra array <<< "$(_sh.value "$1")"
  cat <<< "${array[@]}"
}

String.exit_if_blank? ()  { ! String.blank? "$1" || exit "${2:-0}" ;}

String.new() {
  local method
  local methods

  # shellcheck disable=SC2034
  read -d "" -a methods <<EOS
blank?
eql?
split
exit_if_blank?
EOS

  for method in "${methods[@]}"; do
    alias_method "$1" "$method" "String"
  done
}

alias_method() {
  eval "$1.$2 () { $3.$2 $1 \"\$@\" ;}"
}
