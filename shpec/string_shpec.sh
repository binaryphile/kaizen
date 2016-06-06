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
    nonce="abc"
    str::eql? nonce "abc"
    assert equal $? 0
  end

  it "fails inequality"
    # shellcheck disable=SC2034
    nonce="abc"
    str::eql? nonce "abcd"
    assert unequal $? 0
  end
end
