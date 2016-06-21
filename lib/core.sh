#!/usr/bin/env bash
# Core functions used by other modules

[[ -z $_bl_core_loaded ]] || return 0
declare -r _bl_core_loaded="true"

_sh.strict_mode() {
  case "$1" in
    on )
      set -o errexit
      set -o nounset
      set -o pipefail
      ;;
    off )
      set +o errexit
      set +o nounset
      set +o pipefail
      ;;
  esac
}

_sh.trace() {
  case "$1" in
    "on" )
      set -o xtrace
      ;;
    "off" )
      set +o xtrace
      ;;
  esac
}
