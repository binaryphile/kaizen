#!/usr/bin/env bash
# Functional programming style functions

# https://onthebalcony.wordpress.com/2008/03/08/just-for-fun-map-as-higher-order-function-in-bash/
fnc::apply() {
  local f
  local x

  f="$1"
  x="$2"
  shift 2
  "${f}" "${x}"
  apply "${f}" "$@"
}


