#!/usr/bin/env bash

source lib/string.sh

describe "str::split"
  it "splits on the specified delimiter"
    # shellcheck disable=SC2034
    str="a/b/c"
    result=( "a" "b" "c" )
    assert equal "$(str::split str "/")" "${result[*]}"
  end
end

describe "str::eql?"
  it "checks equality"
    # shellcheck disable=SC2034
    sample="abc"
    str::eql? sample "abc"
    assert equal $? 0
  end

  it "fails inequality"
    # shellcheck disable=SC2034
    sample="abc"
    str::eql? sample "abcd"
    assert unequal $? 0
  end
end

describe "str::blank?"
  it "checks for empty string"
    # shellcheck disable=SC2034
    sample=""
    str::blank? sample
    assert equal $? 0
  end

  it "checks for string with only spaces"
    # shellcheck disable=SC2034
    sample=" "
    str::blank? sample
    assert equal $? 0
  end

  it "checks for string with only tabs"
    # shellcheck disable=SC2034
    sample=" 	"
    str::blank? sample
    assert equal $? 0
  end

  it "doesn't match strings with characters"
    # shellcheck disable=SC2034
    sample="ab "
    str::blank? sample
    assert unequal $? 0
  end
end
