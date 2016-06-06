#!/usr/bin/env bash
# Functions for string manipulation

source ../../../fvue/BashByRef/upvar.sh

str::split () {
  local array

  eval "IFS=\"$2\" read -ra array <<< \$$1"
  echo "${array[@]}"
}

str::is_empty()           {   [[ -z "$1"      ]]  ;}
str::is_equal()           {   [[ "$1" == "$2" ]]  ;}
str::is_match()           {   is_equal "$1" "$2"  ;}
str::is_not_empty()       { ! is_empty "$1"       ;}
str::is_not_equal()       { ! is_equal "$1" "$2"  ;}
str::is_not_match()       { ! is_match "$1" "$2"  ;}
