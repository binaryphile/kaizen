#!/usr/bin/env bash

str::split () {
  printf "%s" "$( IFS="$1"; read -a array <<< "$2"; echo "${array[@]}" )"
}
