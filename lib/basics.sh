#!/usr/bin/env bash

# https://stackoverflow.com/questions/3915040/bash-fish-command-to-print-absolute-path-to-a-file#answer-23002317
abspath () {
  # generate absolute path from relative path
  # $1     : relative filename
  # return : absolute path
  if is_dir "${1}"; then
    (cd "${1}"; pwd)
  elif is_file "${1}"; then
    if [[ "${1}" == */* ]]; then
      echo "$(cd "${1%/*}"; pwd)/${1##*/}"
    else
      echo "$(pwd)/${1}"
    fi
  fi
}

# https://onthebalcony.wordpress.com/2008/03/08/just-for-fun-map-as-higher-order-function-in-bash/
apply () {
  local f="${1}"
  local x="${2}"
  shift 2
  "${f}" "${x}"
  apply "${f}" "${@}"
}

base_name () {
  echo "${1##*/}"
}

# https://github.com/DinoTools/python-ssdeep/blob/master/ci/run.sh
detect_os () {
  local os

  if is_on_filesystem "/etc/lsb-release"; then
    source /etc/lsb-release
    os="$(echo ${DISTRIB_ID} | awk '{ print tolower($1) }')"
  elif is_on_path "lsb_release"; then
    os="$(lsb_release -i | cut -f2 | awk '{ print tolower($1) }')"
  elif is_on_filesystem "/etc/debian_version"; then
    os="$(cat /etc/issue | head -1 | awk '{ print tolower($1) }')"
  elif is_on_filesystem "/etc/fedora-release"; then
    os="fedora"
  elif is_on_filesystem "/etc/oracle-release"; then
    os="ol"
  elif is_on_filesystem "/etc/redhat-release"; then
    os="$(cat /etc/redhat-release  | awk '{ print tolower($1) }')"
    match "${os}" "centos" || match "${os}" "scientific" || os="redhatenterpriseserver"
  fi
  echo "${os}"
}

# https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr#answer-2990533
echoerr () {
  cat <<< "${@}" 1>&2;
}

errexit_is_set () {
  [[ "${-}" =~ e ]]
}

exit_if_is_directory () {
  ! is_directory "${1}" || exit
}

exit_if_is_link () {
  ! is_link "${1}" || exit
}

exit_if_is_on_path () {
  ! is_on_path "${1}" || exit
}

exit_if_package_is_installed () {
  ! package_is_installed "${1}" || exit
}

is_file () {
  [[ -f "${1}" ]]
}

is_directory () {
  [[ -d "${1}" ]]
}

is_empty () {
  [[ -z "${1}" ]]
}

is_link () {
  [[ -h "${1}" ]]
}

is_on_filesystem () {
  [[ -e "${1}" ]]
}

is_on_path () {
  which "${1}" >/dev/null 2>&1
}

load_config () {
  load_yml etc/defaults.yml
  is_empty "${1}" && return
  load_yml "etc/${1}"
}

load_yml () {
  eval "$(parse_yml "${@}")"
}

make_symlink () {
  ln -sfT "${2}" "${1}"
}

make_group_dir () {
  sudo mkdir "${1}"
  sudo chown "${USER}:${2:-prodadm}" "${1}"
  chmod g+rws "${1}"
  setfacl -m d:g::rwx "${1}"
}

make_group_file () {
  sudo touch "${1}"
  sudo chown "${USER}:${2:-prodadm}" "${1}"
  chmod g+rw "${1}"
}

match () {
  [[ "${1}" == "${2}" ]]
}

nounset_is_set () {
  [[ "${-}" =~ u ]]
}

parse_yml () {
  # http://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script#answer-21189044
  # parse a yml file into flattened variable names, concatenated with underscore
  # - argument allows specifying a prefix for the returned variables so they are namespaced
  # - eval the return value to set the variables globally, e.g.  "eval $(parse_yml filename)"
  # - does not handle yml lists, only dictionaries
  local prefix=$2
  local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
  sed -ne "s|^\($s\):|\1|" \
       -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
       -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
  awk -F$fs '{
    indent = length($1)/2;
    vname[indent] = $2;
    for (i in vname) {if (i > indent) {delete vname[i]}}
    if (length($3) > 0) {
      vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
      printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
    }
  }'
}

pop_dir () {
  popd >/dev/null
}

push_dir () {
  pushd "${1}" >/dev/null
}

# http://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced#answer-14706745
script_is_sourced () {
  [[ ${FUNCNAME[ (( ${#FUNCNAME[@]:-} - 1 ))]:-} == "source" ]]
}

source_relaxed () {
  local errexit
  local nounset

  ! file_exists "${1}" && return
  errexit_is_set && errexit="y"
  nounset_is_set && nounset="y"
  set +o errexit
  set +o nounset
  source "${1}"
  ! is_empty "${errexit}" && set -o errexit
  ! is_empty "${nounset}" && set -o nounset
}

strict_mode_off () {
  set +o errexit
  set +o nounset
  set +o pipefail
}

strict_mode_on () {
  set -o errexit
  set -o nounset
  set -o pipefail
}

substitute_in_file () {
  sed -i -e "s|${2}|${3}|" "${1}"
}

trace_off () {
  set +o xtrace
}

trace_on () {
  set -o xtrace
}
