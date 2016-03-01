#!/usr/bin/env bash
# vim: set ft=sh:

source lib/stringlib

describe "str_join"
  it "joins array elements"
    array=( a b c )
    assert equal "$(str_join "|" "${array[@]}")" "a|b|c"
  end

  it "allows a multicharacter delimiter"
    array=( a b c )
    assert equal "$(str_join " | " "${array[@]}")" "a | b | c"
  end
end

describe "str_split"
  it "splits on the specified delimiter"
    str="a/b/c"
    result=( a b c )
    assert equal "$(str_split "/" "${str}")" "${result[*]}"
  end
end
