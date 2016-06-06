#!/usr/bin/env bash
# Functional programming style functions

# https://onthebalcony.wordpress.com/2008/03/08/just-for-fun-map-as-higher-order-function-in-bash/
fnc::map() {
  [[ $# -gt 1 ]] || return 0

  local func="$1"
  local param="$2"
  shift 2
  "${func}" "${param}"
  fnc::map "${func}" "$@"
}


