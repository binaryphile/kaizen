#!/usr/bin/env bash

source lib/string.sh

describe "str::split"
  it "splits on the specified delimiter"
    str="a/b/c"
    result=( a b c )
    assert equal "$(str::split "/" "${str}")" "${result[*]}"
  end
end
