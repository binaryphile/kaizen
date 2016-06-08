#!/usr/bin/env bash
# Functions for interacting with the user

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="$PWD"

source "$_lib_dir"/core.sh

core.blank? _ui_loaded || return 0
# shellcheck disable=SC2034
declare -r _ui_loaded="true"

# Let the user make a choice about something and execute code based on
# the answer
# Called like: choose <default (y or n)> <prompt>
# e.g. choose "y" \
#       "Do you want to play a game?" \
# Returns: 0 for yes and 1 for anything else
ui.choose() {
  local default
  local prompt
  local answer

  default="$1"
  prompt="$2"
  read -ep "$prompt" answer
  ! core.blank? answer || answer="$default"

  case "$answer" in
    [yY1] ) return 0
      # error check
      ;;
    *     ) return 1
  esac
}

# https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr#answer-2990533
ui.echoerr() {
  cat <<< "$@" 1>&2;
}

ui.default_flags() {
  DEFINE_boolean 'trace'  false 'enable tracing'      't'
  DEFINE_boolean 'strict' true  'enable strict mode'
}

ui.exec_flags() {
  core.eql? FLAGS_trace  "$FLAGS_FALSE" || core.trace on
  core.eql? FLAGS_strict "$FLAGS_FALSE" || core.strict_mode on
}

ui.usage_and_exit_if_blank? () {
  if core.blank? "1"; then
    usage
    exit 1
  fi
}
