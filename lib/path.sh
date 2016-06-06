#!/usr/bin/env bash
# Functions dealing with files and paths

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="${PWD}"

source "${_lib_dir}/core.sh"

cor::blank? _path_loaded || return 0
# shellcheck disable=SC2034
declare -r _path_loaded="true"

# https://github.com/basecamp/sub/blob/master/libexec/sub
pth::abs_dirname() {
  local cwd
  local path="$1"

  cwd="$(pwd)"
  while [[ -n "${path}" ]]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(resolve_link "${name}" || true)"
  done

  pwd
  cd "${cwd}"
}

pth::base_name()            {   printf "%s" "${1##*/}"  ;}
pth::exit_if_is_directory() { ! is_directory "$1" || exit "${2:-0}" ;}
pth::exit_if_is_file ()     { ! is_file "$1"      || exit "${2:-0}" ;}
pth::exit_if_is_link()      { ! is_link "$1"      || exit "${2:-0}" ;}
pth::is_directory()         {   [[ -d "$1" ]]           ;}
pth::is_file()              {   [[ -f "$1" ]]           ;}
pth::is_link()              {   [[ -h "$1" ]]           ;}
pth::is_not_directory()     { ! is_directory "$1"       ;}
pth::is_not_file()          { ! is_file "$1"            ;}
pth::is_not_older_than()    { ! [[ "$1" -ot "$2" ]]     ;} # NOT the same as is_newer_than since they can be equal
pth::is_on_filesystem()     {   [[ -e "$1" ]]           ;}

pth::make_group_file() {
  local filename="$1"
  sudo touch "${filename}"
  sudo chown "${USER}:${2:-prodadm}" "${filename}"
  chmod g+rw "${filename}"
}

pth::make_symlink()         { ln -sfT "$2" "$1"         ;}

pth::make_group_dir() {
  local dirname="$1"
  sudo mkdir "${dirname}"
  sudo chown "${USER}:${2:-prodadm}" "${dirname}"
  chmod g+rwxs "${dirname}"
  setfacl -m d:g::rwx "${dirname}"
}

pth::readlink() { eval "readlink \"\$$1\""  ;}
pth::substitute_in_file() { sed -i -e "s|$2|$3|" "$1" ;}
