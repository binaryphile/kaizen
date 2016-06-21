#!/usr/bin/env bash
# Functions for interacting with the user

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -n $_bl_lib_dir ]] || {
  if [[ -d ${BASH_SOURCE%/*} ]]; then
    declare -r _bl_lib_dir="${BASH_SOURCE%/*}"
  else
    declare -r _bl_lib_dir="$PWD"
  fi
}

[[ -n $RUBSH_PATH ]] || export RUBSH_PATH="$_bl_lib_dir"
source "$_bl_lib_dir"/rubsh/rubsh.sh

require "core"

String.blank? _bl_ui_loaded || return 0
# TODO: use sha1
# shellcheck disable=SC2034
declare -r _bl_ui_loaded="true"


# Let the user make a choice about something and execute code based on
# the answer
# Called like: choose <default (y or n)> <prompt>
# e.g. choose "y" \
#       "Do you want to play a game?" \
# Returns: 0 for yes and 1 for anything else
ui.choose() {
  local answer
  local default="$1"
  local prompt="$2"

  read -ep "$prompt" answer
  ! _String.blank? answer || answer="$default"

  case "$answer" in
    [yY1] )
      return 0
      # error check
      ;;
    * )
      return 1
      ;;
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
  _String.eql? FLAGS_trace  "$FLAGS_FALSE" || _sh.trace on
  _String.eql? FLAGS_strict "$FLAGS_FALSE" || _sh.strict_mode on
}

ui.usage_and_exit_if_blank? () {
  if _String.blank? "1"; then
    usage
    exit 1
  fi
}
