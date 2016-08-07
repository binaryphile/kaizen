#!/usr/bin/env bash
# Functions for interacting with the user

[[ -z $_bashlib_options ]] || return 0

# shellcheck disable=SC2046,SC2155
readonly _bashlib_options="$(set -- $(sha1sum "$BASH_SOURCE"); echo "$1")"
export _bashlib_options

source "${BASH_SOURCE%/*}"/core.sh 2>/dev/null || source core.sh
# shellcheck disable=SC2154
source "$_rubsh_lib"/string.sh

declare -A options option_boolean_values option_descriptions
export options option_boolean_values option_descriptions

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

# shellcheck disable=SC2154
option_boolean_values[false]=0
# shellcheck disable=SC2154
option_boolean_values[true]=1

options.define() {
  # shellcheck disable=SC2034
  local name=$1
  local type=$2
  # shellcheck disable=SC2034
  local default=$3
  # shellcheck disable=SC2034
  local description=$4
  # shellcheck disable=SC2034
  local short_name=$5

  # shellcheck disable=SC2015
  [[ $type != "boolean" ]] && options[:$name]="$default" || options[:$name]="${option_boolean_values[$default]}"
  option_descriptions[:$name]="$description"
}
export -f options.define

options.parse() {
  local _options_ref=$1

  (( $# )) || return 0
  ! { (( $# == 1 )) && Shell.variable? "$_options_ref" ;} || {
    Shell.dereference :_options_ref
    set -- "${_options_ref[@]}"
  }
  # shellcheck disable=SC1073
  options[:flag]=$(( 1 - options[:flag] ))
}
export -f options.parse

# Dynamically parse a getopt result and set appropriate variables.
#
# This function does the actual conversion of getopt output and runs it through
# the standard case structure for parsing. The case structure is actually quite
# dynamic to support any number of flags.
#
# Args:
#   argc: int: original command-line argument count
#   @: varies: output from getopt parsing
# Returns:
#   integer: a FLAGS success condition
_flags_parseGetopt() {
  local argc=$1; shift
  local opt
  local arg
  local name

  # note the quotes around the `$@' -- they are essential!
  eval set -- "$@"

  # handle options. note options with values must do an additional shift
  while true; do
    opt=$1
    arg=${2:-}

    # determine long flag name
    case $opt in
      --) shift; break ;;  # discontinue option parsing

      --*)  # long option
        opt=$($FLAGS_EXPR_CMD -- "$opt" : '--\(.*\)')
        _flags_len_=$__FLAGS_LEN_LONG
        # shellcheck disable=SC2154,SC2086
        if _flags_itemInList "$opt" $__flags_longNames; then
          name=$opt
        else
          # check for negated long boolean version
          if _flags_itemInList "$opt" $__flags_boolNames; then
            name=$($FLAGS_EXPR_CMD -- "$opt" : 'no\(.*\)')
            type=$_typeBOOLEAN
            arg=$__FLAGS_NULL
          fi
        fi
        ;;

      -*)  # short option
        opt=$(${FLAGS_EXPR_CMD} -- "${opt}" : '-\(.*\)')
        _flags_len_=$__FLAGS_LEN_SHORT
        # shellcheck disable=SC2154,SC2086
        if _flags_itemInList "$opt" $__flags_shortNames; then
          # yes. match short name to long name. note purposeful off-by-one
          # (too high) with awk calculations.
          _flags_pos_=$(echo "${__flags_shortNames}" \
              |awk 'BEGIN{RS=" ";rn=0}$0==e{rn=NR}END{print rn}' \
                  e=${opt})
          name=$(echo "${__flags_longNames}" \
            |awk 'BEGIN{RS=" "}rn==NR{print $0}' rn="${_flags_pos_}")
        fi
        ;;
    esac

    # die if the flag was unrecognized
    if [[ -z $name ]]; then
      flags_error="unrecognized option ($opt)"
      flags_return=$FLAGS_ERROR
      break
    fi

    # set new flag value
    _flags_usName_=$( _flags_underscoreName $name )
    [[ $type == "$_typeNONE" ]] && \
        type=$(_flags_getFlagInfo \
            "$_flags_usName_" $__FLAGS_INFO_TYPE)
    case $type in
      $_typeBOOLEAN)
        if [[ $_flags_len_ == "$__FLAGS_LEN_LONG" ]]; then
          if [[ $arg != "$__FLAGS_NULL" ]]; then
            eval "FLAGS_${flags_usName_}=${FLAGS_TRUE}"
          else
            eval "FLAGS_${_flags_usName_}=${FLAGS_FALSE}"
          fi
        else
          _flags_strToEval_="_flags_val_=\
\${__flags_${_flags_usName_}_${__FLAGS_INFO_DEFAULT}}"
          eval "${_flags_strToEval_}"
          if [ ${_flags_val_} -eq ${FLAGS_FALSE} ]; then
            eval "FLAGS_${_flags_usName_}=${FLAGS_TRUE}"
          else
            eval "FLAGS_${_flags_usName_}=${FLAGS_FALSE}"
          fi
        fi
        ;;

      ${_typeFLOAT})
        if _flags_validFloat "${arg}"; then
          eval "FLAGS_${_flags_usName_}='${arg}'"
        else
          flags_error="invalid float value (${arg})"
          flags_return=${FLAGS_ERROR}
          break
        fi
        ;;

      ${_typeINTEGER})
        if _flags_validInt "${arg}"; then
          eval "FLAGS_${_flags_usName_}='${arg}'"
        else
          flags_error="invalid integer value (${arg})"
          flags_return=${FLAGS_ERROR}
          break
        fi
        ;;

      ${_typeSTRING})
        eval "FLAGS_${_flags_usName_}='${arg}'"
        ;;
    esac

    # handle special case help flag
    if [ "${_flags_usName_}" = 'help' ]; then
      if [ ${FLAGS_help} -eq ${FLAGS_TRUE} ]; then
        flags_help
        flags_error='help requested'
        flags_return=${FLAGS_TRUE}
        break
      fi
    fi

    # shift the option and non-boolean arguements out.
    shift
    [ ${type} != ${_typeBOOLEAN} ] && shift
  done

  # give user back non-flag arguments
  FLAGS_ARGV=''
  while [ $# -gt 0 ]; do
    FLAGS_ARGV="${FLAGS_ARGV:+${FLAGS_ARGV} }'$1'"
    shift
  done
}
