#!/usr/bin/env bash
# Functions for interacting with the user

[[ -z $_bashlib_ui ]] || return 0

# shellcheck disable=SC2046,SC2155
readonly _bashlib_ui="$(set -- $(sha1sum "$BASH_SOURCE"); printf "%s" "$1")"

source "${BASH_SOURCE%/*}"/core.sh 2>/dev/null || source core.sh

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
