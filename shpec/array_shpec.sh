#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="$PWD"
_lib_dir="$_shpec_dir"/../lib
source "$_lib_dir"/core.sh
export BASH_PATH="$_lib_dir"

require "array"

describe "Array.include?"
  it "tests for element membership"
    # shellcheck disable=SC2034
    sample_a=( a b c )
    Array.include? sample_a "a"
    assert equal "$?" 0
  end
end

describe "Array.index"
  it "finds the index of the first element on exact match"
    # shellcheck disable=SC2034
    sample_a=( a b c )
    assert equal "$(Array.index sample_a "a")" 0
  end

  it "finds the index of the second element on exact match"
    # shellcheck disable=SC2034
    sample_a=( a b c )
    assert equal "$(Array.index sample_a "b")" 1
  end
end

describe "Array.join"
  it "joins array elements"
    # shellcheck disable=SC2034
    sample_a=( "a" "b" "c" )
    assert equal "$(Array.join sample_a "|")" "a|b|c"
  end

  it "allows a multicharacter delimiter"
  # shellcheck disable=SC2034
    sample_a=( "a" "b" "c" )
    assert equal "$(Array.join sample_a " | ")" "a | b | c"
  end
end

describe "Array.remove"
  it "removes the last element of an array on exact match"
    # shellcheck disable=SC2034
    sample_a=( "a" "b" "c" )
    result_a=( $(Array.remove sample_a "c") )
    expected_a=( "a" "b" )
    assert equal "${result_a[*]}" "${expected_a[*]}"
  end

  it "doesn't remove elements which aren't there"
    # shellcheck disable=SC2034
    sample_a=( "a" "b" "c" )
    result_a=( $(Array.remove sample_a "d") )
    expected_a=( "a" "b" "c" )
    assert equal "${result_a[*]}" "${expected_a[*]}"
  end
end

describe "Array.slice"
  it "returns the middle slice"
    # shellcheck disable=SC2034
    sample_a=( "a" "b" "c" )
    result_a=( $(Array.slice sample_a 1 1) )
    expected_a=( "b" )
    assert equal "${result_a[*]}" "${expected_a[*]}"
  end
end
