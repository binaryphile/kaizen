#!/usr/bin/env bash

source lib/arraylib

describe "array_contains"
  it "tests for element membership"
    letters=( a b c )
    array_contains "a" "${letters[@]}"
    assert equal "${?}" 0
  end
end

describe "array_find"
  it "finds the index of the first element on exact match"
    letters=( a b c )
    assert equal "$(array_find "a" "${letters[@]}")" 0
  end

  it "finds the index of the second element on exact match"
    letters=( a b c )
    assert equal "$(array_find "b" "${letters[@]}")" 1
  end
end
