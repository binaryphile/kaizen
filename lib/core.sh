#!/usr/bin/env bash
# Core functions used by other modules

[[ -z $_bashlib_core ]] || return 0

# shellcheck disable=SC2046
readonly _bashlib_core="$(set -- $(sha1sum "$BASH_SOURCE"); printf "%s" "$1")"

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -n $_bashlib_lib ]]  || readonly _bashlib_lib="$(cd "${BASH_SOURCE%/*}" >/dev/null 2>&1; printf "%s" "$PWD")" # I think this doesn't work correctly if the readonly comes after the assignment...weird scoping

source "$_bashlib_lib"/rubsh/rubsh.sh
