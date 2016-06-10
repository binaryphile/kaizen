#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="$PWD"

source "${_shpec_dir}/../lib/functional.sh"

describe "func.map"
  it "maps an array"
    array=( "a" "b" "c" )
    assert equal "$(func.map "printf" "${array[@]}")" "abc"
  end
end
