#!/usr/bin/env bash

source ../lib/basics.sh

main () {
  local filename
  local filenames=( "${@}" )

  for filename in "${filenames[@]}"; do
    compact "${filename}"
  done
}

compact () {
  local line
  local lines
  local sourcefilename
  local filename="${1}"

  cp "${filename}" "${filename}_"
  filename="${filename}_"
  lines=( $( grep '^source ' "${filename}" ) )
  for line in "${lines[@]}"; do
    [[ "source" == "${line}" ]] && continue
    sourcefilename=abspath "$( dirname "${filename}" )/${line}"
    sed -e '/^#!/d' "$sourcefilename" >> "${filename}"
    sed -i -e '/^source /d' "${filename}"
  done
}

main "${@}"
