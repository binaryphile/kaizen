#!/usr/bin/env bash
# Functions for interacting with the user

[[ -z $_bashlib_options ]] || return 0

# shellcheck disable=SC2046,SC2155
readonly _bashlib_options="$(set -- $(sha1sum "$BASH_SOURCE"); echo "$1")"
export _bashlib_options

source "${BASH_SOURCE%/*}"/core.sh 2>/dev/null || source core.sh
# shellcheck disable=SC2154

declare -A options options_boolean_values options_descriptions
export options
export options_boolean_values
export options_descriptions
export options_short_getopt=""
export options_long_getopt=""

options_boolean_values[:false]=0
options_boolean_values[:0]=0
options_boolean_values[:true]=1
options_boolean_values[:1]=1

options._add_short_option() {
  local aso_return_name=$1
  local aso_getopt_options=$1
  local aso_name=$2
  local aso_type=$3

  Shell.dereference :aso_getopt_options
  Shell.dereference :aso_name
  Shell.dereference :aso_type
  aso_getopt_options+=$aso_name
  [[ $aso_type == ":boolean" ]] || aso_getopt_options+=:
  local "$(Symbol.to_s "$aso_return_name")"
  Shell.passback_as "$aso_return_name" "$aso_getopt_options"
}
export -f options._add_short_option

options._add_long_option() {
  local alo_return_name=$1
  local alo_getopt_options=$1
  local alo_name=$2
  local alo_type=$3

  Shell.dereference :alo_getopt_options
  Shell.dereference :alo_name
  Shell.dereference :alo_type
  alo_getopt_options+=${alo_getopt_options:+,}$alo_name
  [[ $alo_type == ":boolean" ]] || alo_getopt_options+=:
  local "$(Symbol.to_s "$alo_return_name")"
  Shell.passback_as "$alo_return_name" "$alo_getopt_options"
}
export -f options._add_long_option

options.default_flags() {
  DEFINE_boolean 'trace'  false 'enable tracing'      't'
  DEFINE_boolean 'strict' true  'enable strict mode'
}
export -f options.default_flags

options.exec_flags() {
  _String.eql? FLAGS_trace  "$FLAGS_FALSE" || _Shell.trace on
  _String.eql? FLAGS_strict "$FLAGS_FALSE" || _Shell.strict_mode on
}
export -f options.exec_flags

options.define() {
  # shellcheck disable=SC2034
  local def_name=$1
  local def_type=$2
  # shellcheck disable=SC2034
  local def_default=$3
  # shellcheck disable=SC2034
  local def_description=$4
  # shellcheck disable=SC2034
  local def_short_name=$5
  # TODO: figure out why using the globals directly doesn't work
  local def_options=""

  (( $# > 3 )) || return
  # shellcheck disable=SC2015,SC2102
  if [[ $def_type == ":boolean" ]]; then
    # shellcheck disable=SC2086
    options[:$def_name]=${options_boolean_values[:$def_default]}
  else
    # shellcheck disable=SC2086
    options[:$def_name]=$def_default
  fi
  # shellcheck disable=SC2154,SC2102
  options_descriptions[:$def_name]="$def_description"
  new def_options = options._add_long_option :def_name :def_type
  options_long_getopt=$def_options
  (( $# > 4 )) || return 0
  def_options=""
  new def_options = options._add_short_option :def_short_name :def_type
  options_short_getopt=$def_options
}
export -f options.define

options._get_getopt_options() {
  local ggo_ref=$1
  local ggo_getopt_params

  ggo_getopt_params="--options=$options_short_getopt --long-options=$options_long_getopt"
  local "$(Symbol.to_s "$ggo_ref")"
  Shell.passback_as "$ggo_ref" "$ggo_getopt_params"
}
export -f _options.get_getopt_options

options.parse() {
  local options_par_ref=$1
  # shellcheck disable=SC2034
  local options_par_getopt

  (( $# )) || return 0
  { (( $# > 1 )) || ! Shell.variable? "$options_par_ref" ;} || {
    Shell.dereference :options_par_ref
    set -- "${options_par_ref[@]}"
  }
  _options.get_getopt_options :options_par_getopt
  _options.parse_getopt_options :options_par_getopt "$@"
}
export -f options.parse
