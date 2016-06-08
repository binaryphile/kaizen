#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="${PWD}"

source "${_shpec_dir}/../lib/_core.sh"

myfunc() { echo "hello"; }

describe "_core.alias_function"
  it "aliases a function"
    _core.alias_function myfunc2 myfunc
    assert equal "$(myfunc2)" "hello"
  end
end

describe "_core.blank?"
  it "checks for empty string"
    # shellcheck disable=SC2034
    sample=""
    _core.blank? sample
    assert equal $? 0
  end

  it "checks for string with only spaces"
    # shellcheck disable=SC2034
    sample=" "
    _core.blank? sample
    assert equal $? 0
  end

  it "checks for string with only tabs"
    # shellcheck disable=SC2034
    sample=" 	"
    _core.blank? sample
    assert equal $? 0
  end

  it "doesn't match strings with characters"
    # shellcheck disable=SC2034
    sample="ab "
    _core.blank? sample
    assert unequal $? 0
  end
end

describe "_core.deref"
  it "dereferences a scalar variable"
    # shellcheck disable=SC2034
    sample="text"
    # shellcheck disable=SC2034
    indirect="sample"
    _core.deref indirect
    assert equal "$indirect" "text"
  end

  it "dereferences an array variable"
    # shellcheck disable=SC2034
    sample=("testing" "one" "two")
    # shellcheck disable=SC2034
    indirect="sample"
    _core.deref indirect
    assert equal "${#indirect}" 3
    assert equal "${indirect[*]}" "testing one two"
  end
end

describe "_core.eql?"
  it "checks equality"
    # shellcheck disable=SC2034
    sample="abc"
    _core.eql? sample "abc"
    assert equal $? 0
  end

  it "fails inequality"
    # shellcheck disable=SC2034
    sample="abc"
    _core.eql? sample "abcd"
    assert unequal $? 0
  end
end

describe "_core.value"
  it "prints the value"
    # shellcheck disable=SC2034
    sample="value"
    assert equal "$(_core.value sample)" "value"
  end
end
