#!/usr/bin/env bash
# Functions for string manipulation

str::split () {
  IFS="$1"
  read -a array <<< "$2"
  echo "${array[@]}"
}

str::exit_if_is_empty()   { ! is_empty "$1"   || exit "${2:-0}"; }
str::exit_if_is_on_path() { ! is_on_path "$1" || exit "${2:-0}"; }
str::is_empty()           {   [[ -z "$1"      ]]; }
str::is_equal()           {   [[ "$1" == "$2" ]]; }
str::is_match()           {   is_equal "$1" "$2"; }
str::is_not_empty()       { ! is_empty "$1";      }
str::is_not_equal()       { ! is_equal "$1" "$2"; }
str::is_not_match()       { ! is_match "$1" "$2"; }
