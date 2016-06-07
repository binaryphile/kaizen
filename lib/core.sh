#!/usr/bin/env bash
# Functional programming style functions

[[ -z $_core_loaded ]] || return 0
declare -r _core_loaded="true"

cor.blank? ()  { eval "[[ -z \${$1:-} ]] || [[ \${$1:-} =~ ^[[:space:]]+$ ]]"  ;}
cor.eql? ()    { eval "[[ \${$1:-} == $2 ]]" ;}

cor.strict_mode() {
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

cor.trace() {
  case "$1" in
    "on" )
      set -o xtrace
      ;;
    "off" )
      set +o xtrace
      ;;
  esac
}
