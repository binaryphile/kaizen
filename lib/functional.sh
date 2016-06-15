#!/usr/bin/env bash
# Functional programming style functions

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="$PWD"

source "$_lib_dir"/core.sh

_String.blank? _functional_loaded || return 0
# shellcheck disable=SC2034
declare -r _functional_loaded="true"

# https://onthebalcony.wordpress.com/2008/03/08/just-for-fun-map-as-higher-order-function-in-bash/
fp.map() {
  [[ $# -gt 1 ]] || return 0

  local func="$1"
  local param="$2"
  shift 2
  "$func" "$param"
  fp.map "$func" "$@"
}
