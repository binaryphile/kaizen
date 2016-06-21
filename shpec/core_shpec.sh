#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
if [[ -d ${BASH_SOURCE%/*} ]]; then
  _shpec_dir="${BASH_SOURCE%/*}"
else
  _shpec_dir="$PWD"
fi

_lib_dir="$_shpec_dir"/../lib

source "$_lib_dir"/core.sh
