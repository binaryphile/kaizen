#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="${PWD}"

source "$_shpec_dir"/../lib/string.sh

describe "str.split"
  it "splits on the specified delimiter"
    # shellcheck disable=SC2034
    sample="a/b/c"
    result=( $(str.split sample "/") )
    assert equal "$(str.split sample "/")" "${result[*]}"
  end
end

describe "str.eql?"
  it "exists"
    # shellcheck disable=SC2034
    mystr="abc"
    str.eql? mystr "abc"
    assert equal $? 0
  end
end

describe "str.blank?"
  it "exists"
    # shellcheck disable=SC2034
    mystr=""
    str.blank? mystr
    assert equal $? 0
  end
end
