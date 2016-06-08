#!/usr/bin/env bash
# Functions dealing with files and paths

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="$PWD"

source "$_lib_dir"/_core.sh

_core.blank? _pathname_loaded || return 0
# shellcheck disable=SC2034
declare -r _pathname_loaded="true"

source "$_lib_dir"/file.sh

path.basename() { file.basename "$@"  ;}
path.dirname()  { file.dirname  "$@"  ;}
path.exist? ()  { file.exist?   "$@"  ;}
path.readlink() { file.readlink "$@"  ;}

# https://github.com/basecamp/sub/blob/master/libexec/sub
path.realdirpath() {
  local cwd
  local name
  local path

  core
  eval "local path=\"\$$1\""
  cwd="$(pwd)"
  while ! _core.blank? path; do
    cd "$(file.dirname path)"
    # shellcheck disable=SC2034
    name="$(path.basename path)"
    # shellcheck disable=SC2034
    path="$(file.readlink name || true)"
  done
  pwd
  cd "$cwd"
}
