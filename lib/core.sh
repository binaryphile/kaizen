#!/usr/bin/env bash
# Functional programming style functions

[[ -z $_core_loaded ]] || return 0
declare -r _core_loaded="true"

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="${PWD}"

source "$_lib_dir"/upvar.sh

core.alias_function() { eval "${1}() { $2 \"\$@\" ;}" ;}
core.blank? ()        { eval "[[ -z \${$1:-} ]] || [[ \${$1:-} =~ ^[[:space:]]+$ ]]"  ;}

core.deref() {
  local "_$1"

  read "_$1" <<< "$(core.value "$(core.value "$1")")"
  local "$1" && upvar "$1" "$(core.value "_$1")"
}

core.eql? ()    { eval "[[ \${$1:-} == $2 ]]" ;}

core.strict_mode() {
  case "$1" in
    "on" )
      set -o errexit
      set -o nounset
      set -o pipefail
      ;;
    "off" )
      set +o errexit
      set +o nounset
      set +o pipefail
      ;;
  esac
}

core.trace() {
  case "$1" in
    "on" )
      set -o xtrace
      ;;
    "off" )
      set +o xtrace
      ;;
  esac
}

core.value() { eval printf "%s" "\$$1" ;}
