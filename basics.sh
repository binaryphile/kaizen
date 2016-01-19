#!/usr/bin/env bash

apply () {
  local f="${1}"
  local x="${2}"
  shift 2
  "${f}" "${x}"
  apply "${f}" "${@}"
}

# https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr#answer-2990533
echoerr () {
  cat <<< "${@}" 1>&2;
}

errexit_is_set () {
  [[ "${-}" =~ e ]]
}

file_exists () {
  [[ -f "${1}" ]]
}

is_empty () {
  [[ -z "${1}" ]]
}

load_config () {
  load_yml etc/defaults.yml
  is_empty "${1}" && return
  load_yml "etc/${1}"
}

load_yml () {
  eval "$(parse_yml "${@}")"
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
