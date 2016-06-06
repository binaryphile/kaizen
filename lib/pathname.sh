#!/usr/bin/env bash
# Functions dealing with files and paths

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="$PWD"

source "${_lib_dir}/core.sh"

cor::blank? _path_loaded || return 0
# shellcheck disable=SC2034
declare -r _path_loaded="true"

source "${_lib_dir}/file.sh"

# https://github.com/basecamp/sub/blob/master/libexec/sub
pnm::realdirpath() {
  local cwd
  local name
  eval "local path=\"\$$1\""

  cwd="$(pwd)"
  while ! cor::blank? path; do
    cd "$(fil::dirname path)"
    # shellcheck disable=SC2034
    name="$(pnm::basename path)"
    # shellcheck disable=SC2034
    path="$(fil::readlink name || true)"
  done

  pwd
  cd "${cwd}"
}

pnm::basename() {   eval "printf \"%s\" \"\${$1##*/}\"" ;}
pnm::dirname()  {   fil::dirname "$@"                   ;}
pnm::readlink() {   fil::readlink "$@"                  ;}
