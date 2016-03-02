#!/usr/bin/env bash
# vim: set ft=sh:

source lib/stringlib

describe "str_split"
  it "splits on the specified delimiter"
    str="a/b/c"
    result=( a b c )
    assert equal "$(str_split "/" "${str}")" "${result[*]}"
  end
end
