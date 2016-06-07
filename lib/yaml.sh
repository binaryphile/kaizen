#!/usr/bin/env bash
# Functions for dealing with YAML files

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="${PWD}"

source "${_lib_dir}/core.sh"

cor::blank? _yaml_loaded || return 0
# shellcheck disable=SC2034
declare -r _yaml_loaded="true"

yml.load_config() {
  load_yml etc/defaults.yml
  ! is_empty "$1" || return 0
  load_yml "etc/$1"
}

yml.load_yml()      { eval "$(parse_yml "$@")"; }

yml.parse_yml() {
  # http://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script#answer-21189044
  # parse a yml file into flattened variable names, concatenated with underscore
  # - argument allows specifying a prefix for the returned variables so they are namespaced
  # - eval the return value to set the variables globally, e.g.  "eval $(parse_yml filename)"
  # - does not handle yml lists, only dictionaries
  local prefix
  local fs
  local s
  local w

  prefix="$2"
  s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
  sed -ne "s|^\(${s}\):|\1|" \
    -e "s|^\(${s}\)\(${w}\)${s}:${s}[\"']\(.*\)[\"']${s}\$|\1$fs\2$fs\3|p" \
    -e "s|^\(${s}\)\(${w}\)${s}:${s}\(.*\)${s}\$|\1$fs\2$fs\3|p"  "$1" |
  awk -F"${fs}" '{
  indent = length($1)/2;
  vname[indent] = $2;
  for (i in vname) {if (i > indent) {delete vname[i]}}
    if (length($3) > 0) {
      vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
      printf("%s%s%s=\"%s\"\n", "'${prefix}'",vn, "$2", "$3");
    }
  }'
}
