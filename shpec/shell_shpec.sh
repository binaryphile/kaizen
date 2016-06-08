#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="${PWD}"

source "${_shpec_dir}/../lib/shell.sh"

describe "sh.class"
  it "reports if it is an array"
    # shellcheck disable=SC2034
    ary=( 1 2 3 )
    assert equal "$(sh.class ary)" "array"
  end
end
