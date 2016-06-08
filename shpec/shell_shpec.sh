#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="${PWD}"

source "${_shpec_dir}/../lib/shell.sh"

describe "sh.value"
  it "prints the value"
    # shellcheck disable=SC2034
    sample="value"
    assert equal "$(sh.value sample)" "value"
  end
end

describe "sh.deref"
  it "dereferences the variable"
    # shellcheck disable=SC2034
    sample="text"
    # shellcheck disable=SC2034
    indirect="sample"
    sh.deref indirect
    assert equal "$indirect" "text"
  end
end
