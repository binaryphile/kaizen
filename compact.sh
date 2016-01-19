#!/usr/bin/env bash

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
  local filename="${1}"

  cp "${filename}" "${filename}_"
  filename="${filename}_"
  lines=( $( grep '^source ' "${filename}" ) )
  for line in "${lines[@]}"; do
    [[ "source" == "${line}" ]] && continue
    sed -e '/^#!/d' "${line}" >> "${filename}"
    sed -i -e '/^source /d' "${filename}"
  done
}

main "${@}"
