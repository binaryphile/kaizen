#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="${PWD}"

source "${_shpec_dir}/../lib/core.sh"

myfunc() { echo "hello"; }

describe "core.alias_function"
  it "aliases a function"
    core.alias_function myfunc2 myfunc
    assert equal "$(myfunc2)" "hello"
  end
end
