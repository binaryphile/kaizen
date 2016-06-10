#!/usr/bin/env bash
# Functions dealing with files and paths

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="$PWD"

source "$_lib_dir"/core.sh

_str.blank? _file_loaded || return 0
# shellcheck disable=SC2034
declare -r _file_loaded="true"

# TODO: use _sh.value etc?
file.basename()   { eval printf "%s" "\${$1##*/}" ;}
file.dirname()    { eval printf "%s" "\${$1%/*}"  ;}
file.exist? ()    { eval [[ -f \$"$1" ]]          ;}
file.readlink()   { eval readlink "\$$1"          ;}
file.symlink? ()  { eval [[ -h \$"$1" ]]          ;}
