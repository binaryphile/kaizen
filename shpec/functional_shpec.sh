#!/usr/bin/env bash

source lib/functional.sh

describe "fnc::map"
  it "maps an array"
    array=( 1 2 3 )
    assert equal "$(fnc::map "printf" "${array[@]}")" "123"
  end
end
