#!/usr/bin/env bash

source lib/array.sh

describe "ary::join"
  it "joins array elements"
    array=( a b c )
    assert equal "$(ary::join "|" "${array[@]}")" "a|b|c"
  end

  it "allows a multicharacter delimiter"
    array=( a b c )
    assert equal "$(ary::join " | " "${array[@]}")" "a | b | c"
  end
end

describe "ary::contains"
  it "tests for element membership"
    letters=( a b c )
    ary::contains "a" "${letters[@]}"
    assert equal "$?" 0
  end
end

describe "ary::find"
  it "finds the index of the first element on exact match"
    letters=( a b c )
    assert equal "$(ary::find "a" "${letters[@]}")" 0
  end

  it "finds the index of the second element on exact match"
    letters=( a b c )
    assert equal "$(ary::find "b" "${letters[@]}")" 1
  end
end

describe "ary::remove"
  it "removes the last element of an array on exact match"
    letters=( a b c )
    result=( $(ary::remove "c" "${letters[@]}") )
    target=( a b )
    assert equal "${result[*]}" "${target[*]}"
  end

  it "doesn't remove elements which aren't there"
    letters=( a b c )
    result=( $(ary::remove "d" "${letters[@]}") )
    target=( a b c )
    assert equal "${result[*]}" "${target[*]}"
  end
end

describe "ary::slice"
  it "returns the middle slice"
    letters=( a b c )
    result=( $(ary::slice "1" "1" "${letters[@]}") )
    target=( b )
    assert equal "${result[*]}" "${target[*]}"
  end
end
