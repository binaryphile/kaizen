#!/usr/bin/env bash
# vim: ft=sh

source lib/array.sh

describe "ary_join"
  it "joins array elements"
    array=( a b c )
    assert equal "$(ary_join "|" "${array[@]}")" "a|b|c"
  end

  it "allows a multicharacter delimiter"
    array=( a b c )
    assert equal "$(ary_join " | " "${array[@]}")" "a | b | c"
  end
end

describe "ary_contains"
  it "tests for element membership"
    letters=( a b c )
    ary_contains "a" "${letters[@]}"
    assert equal "${?}" 0
  end
end

describe "ary_find"
  it "finds the index of the first element on exact match"
    letters=( a b c )
    assert equal "$(ary_find "a" "${letters[@]}")" 0
  end

  it "finds the index of the second element on exact match"
    letters=( a b c )
    assert equal "$(ary_find "b" "${letters[@]}")" 1
  end
end

describe "ary_remove"
  it "removes the last element of an array on exact match"
    letters=( a b c )
    result=( $(ary_remove "c" "${letters[@]}") )
    target=( a b )
    assert equal "${result[*]}" "${target[*]}"
  end

  it "doesn't remove elements which aren't there"
    letters=( a b c )
    result=( $(ary_remove "d" "${letters[@]}") )
    target=( a b c )
    assert equal "${result[*]}" "${target[*]}"
  end
end

describe "ary_slice"
  it "returns the middle slice"
    letters=( a b c )
    result=( $(ary_slice "1" "1" "${letters[@]}") )
    target=( b )
    assert equal "${result[*]}" "${target[*]}"
  end
end
