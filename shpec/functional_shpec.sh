#!/usr/bin/env bash

source lib/functional.sh

describe "fnc::map"
  it "maps an array"
    array=( "a" "b" "c" )
    assert equal "$(fnc::map "printf" "${array[@]}")" "abc"
  end
end
