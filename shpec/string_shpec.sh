#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="${PWD}"

source "${_shpec_dir}/../lib/string.sh"

describe "str.split"
  it "splits on the specified delimiter"
    # shellcheck disable=SC2034
    sample="a/b/c"
    result=( $(str.split sample "/") )
    assert equal ${#result[@]} 3
    assert equal "${result[2]}" "c"
  end
end

describe "str.eql?"
  it "checks equality"
    # shellcheck disable=SC2034
    sample="abc"
    str.eql? sample "abc"
    assert equal $? 0
  end

  it "fails inequality"
    # shellcheck disable=SC2034
    sample="abc"
    str.eql? sample "abcd"
    assert unequal $? 0
  end
end

describe "str.blank?"
  it "checks for empty string"
    # shellcheck disable=SC2034
    sample=""
    str.blank? sample
    assert equal $? 0
  end

  it "checks for string with only spaces"
    # shellcheck disable=SC2034
    sample=" "
    str.blank? sample
    assert equal $? 0
  end

  it "checks for string with only tabs"
    # shellcheck disable=SC2034
    sample=" 	"
    str.blank? sample
    assert equal $? 0
  end

  it "doesn't match strings with characters"
    # shellcheck disable=SC2034
    sample="ab "
    str.blank? sample
    assert unequal $? 0
  end
end
