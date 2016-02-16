#!/usr/bin/env bash

source lib/arraylib

describe "the contains function"
  it "tests for element membership"
    letters=( a b c )
    array_contains "a" "${letters[@]}"
    assert equal "$?" 0
  end
end
