#!/usr/bin/env bash
# Functions dealing with files and paths

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="${PWD}"

source "${_lib_dir}/core.sh"

cor.blank? _file_loaded || return 0
# shellcheck disable=SC2034
declare -r _file_loaded="true"

fil.dirname()  {   eval "printf \"%s\" \"\${$1%/*}\""  ;}
fil.readlink() {   eval "readlink \"\$$1\""            ;}
