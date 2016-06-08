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

describe "core.blank?"
  it "checks for empty string"
    # shellcheck disable=SC2034
    sample=""
    core.blank? sample
    assert equal $? 0
  end

  it "checks for string with only spaces"
    # shellcheck disable=SC2034
    sample=" "
    core.blank? sample
    assert equal $? 0
  end

  it "checks for string with only tabs"
    # shellcheck disable=SC2034
    sample=" 	"
    core.blank? sample
    assert equal $? 0
  end

  it "doesn't match strings with characters"
    # shellcheck disable=SC2034
    sample="ab "
    core.blank? sample
    assert unequal $? 0
  end
end

describe "core.deref"
  it "dereferences a scalar variable"
    # shellcheck disable=SC2034
    sample="text"
    # shellcheck disable=SC2034
    indirect="sample"
    core.deref indirect
    assert equal "$indirect" "text"
  end
end

describe "core.eql?"
  it "checks equality"
    # shellcheck disable=SC2034
    sample="abc"
    core.eql? sample "abc"
    assert equal $? 0
  end

  it "fails inequality"
    # shellcheck disable=SC2034
    sample="abc"
    core.eql? sample "abcd"
    assert unequal $? 0
  end
end

describe "core.value"
  it "prints the value"
    # shellcheck disable=SC2034
    sample="value"
    assert equal "$(core.value sample)" "value"
  end
end
