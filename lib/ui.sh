#!/usr/bin/env bash

# Let the user make a choice about something and execute code based on
# the answer
# Called like: choose <default (y or n)> <prompt>
# e.g. choose "y" \
#       "Do you want to play a game?" \
# Returns: 0 for yes and 1 for anything else
choose () {
  local default
  local prompt
  local answer

  default="$1"
  prompt="$2"
  read -ep "${prompt}" answer
  is_not_empty "${answer}" || answer="${default}"

  case "${answer}" in
    [yY1] ) return 0
      # error check
      ;;
    *     ) return 1
  esac
}

# https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr#answer-2990533
echoerr () {
  cat <<< "$@" 1>&2;
}

default_flags () {
  DEFINE_boolean 'trace' false 'enable tracing' 't'
  DEFINE_boolean 'strict' true 'enable strict mode'
}

exec_flags () {
  is_match "${FLAGS_trace}" "${FLAGS_FALSE}" || trace on
  is_match "${FLAGS_strict}" "${FLAGS_FALSE}" || strict_mode on
}
