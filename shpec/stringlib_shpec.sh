#!/usr/bin/env bash
# vim: set ft=sh:

source lib/stringlib

describe "the string joining function"
  it "joins array elements"
    array=( a b c )
    assert equal "$(str_join "|" "${array[@]}")" "a|b|c"
  end

  it "allows a multicharacter delimiter"
    array=( a b c )
    assert equal "$(str_join " | " "${array[@]}")" "a | b | c"
  end
end
