#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="${PWD}"

source "${_shpec_dir}/../lib/core.sh"

sample_f() { echo "hello"; }

describe "_core.alias_core"
  it "aliases str.blank? function to core"
    # shellcheck disable=SC2034
    aliases_a=( "blank?" )
    _core.alias_core str aliases_a
    # shellcheck disable=SC2034
    blank_s=""
    str.blank? blank_s
    assert equal $? 0
  end
end

describe "_sh.alias_function"
  it "aliases a function"
    _sh.alias_function sample2_f sample_f
    assert equal "$(sample2_f)" "hello"
  end
end

describe "_str.blank?"
# TODO: fail undefined test
  it "checks for empty string"
    # shellcheck disable=SC2034
    sample_s=""
    _str.blank? sample_s
    assert equal $? 0
  end

  it "checks for string with only spaces"
    # shellcheck disable=SC2034
    sample_s=" "
    _str.blank? sample_s
    assert equal $? 0
  end

  it "checks for string with only tabs"
    # shellcheck disable=SC2034
    sample_s=" 	"
    _str.blank? sample_s
    assert equal $? 0
  end

  it "doesn't match strings with characters"
    # shellcheck disable=SC2034
    sample_s="ab "
    _str.blank? sample_s
    assert equal $? 1
  end
end

describe "_sh.class"
  it "reports if it is an array"
    # shellcheck disable=SC2034
    sample_a=( 1 2 3 )
    assert equal "$(_sh.class sample_a)" "array"
  end

  it "reports if it is a string"
    # shellcheck disable=SC2034
    sample_s="value"
    assert equal "$(_sh.class sample_s)" "string"
  end
end

describe "_sh.deref"
  it "dereferences a scalar variable"
    # shellcheck disable=SC2034
    sample_s="text"
    # shellcheck disable=SC2034
    indirect_v="sample_s"
    _sh.deref indirect_v
    assert equal "$indirect_v" "text"
  end

  it "dereferences an array variable"
    # shellcheck disable=SC2034
    sample_a=( "testing" "one" "two" )
    # shellcheck disable=SC2034
    indirect_v="sample_a"
    _sh.deref indirect_v
    assert equal "$(_sh.class indirect_v)" "array"
    assert equal "${indirect_v[*]}" "${sample_a[*]}"
  end
end

describe "_str.eql?"
  it "checks equality"
    # shellcheck disable=SC2034
    sample_s="abc"
    _str.eql? sample_s "$sample_s"
    assert equal $? 0
  end

  it "fails inequality"
    # shellcheck disable=SC2034
    sample_s="abc"
    _str.eql? sample_s ""
    assert equal $? 1
  end
end

describe "_sh.value"
  it "returns a scalar value"
    # shellcheck disable=SC2034
    sample_s="value"
    assert equal "$(_sh.value sample_s)" "$sample_s"
  end

  it "returns an array value"
    # shellcheck disable=SC2034
    sample_a=( "one" "two" "three" )
    assert equal "$(_sh.value sample_a)" "$(printf "%s " "${sample_a[@]}")"
  end
end