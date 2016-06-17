#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="$PWD"
_lib_dir="$_shpec_dir"/../lib
source "$_lib_dir"/core.sh
export BASH_PATH="$_lib_dir"

require "array"

describe "Array.=="
  it "tests equality of two arrays"
    sample_a=( "a" "b" "c" )
    expected_a=( "a" "b" "c" )
    Array.== sample_a expected_a
    assert equal $? 0
  end

  it "detects inequality of two equal-length arrays"
    sample_a=( "a" "b" "c" )
    expected_a=( "a" "b" "d" )
    Array.== sample_a expected_a
    assert equal $? 1
  end

  it "detects inequality of two unequal-length arrays"
    sample_a=( "a" "b" "c" )
    expected_a=( "a" "b" "c" "d" )
    Array.== sample_a expected_a
    assert equal $? 1
  end
end

describe "Array.eql?"
  it "tests equality of two arrays"
    sample_a=( "a" "b" "c" )
    expected_a=( "a" "b" "c" )
    Array.eql? sample_a expected_a
    assert equal $? 0
  end

  it "detects inequality of two equal-length arrays"
    sample_a=( "a" "b" "c" )
    expected_a=( "a" "b" "d" )
    Array.eql? sample_a expected_a
    assert equal $? 1
  end

  it "detects inequality of two unequal-length arrays"
    sample_a=( "a" "b" "c" )
    expected_a=( "a" "b" "c" "d" )
    Array.eql? sample_a expected_a
    assert equal $? 1
  end
end

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

describe "Array.new"
  it "adds an include? method"
    # shellcheck disable=SC2034
    sample_a=( "" )
    Array.new sample_a
    sample_a.include? "a"
    assert equal $? 1
  end

  it "allows an initializer"
    # shellcheck disable=SC2034
    declare sample_a
    Array.new sample_a '( "a" "b" "c" )'
    expected_a=( "a" "b" "c" )
    sample_a.eql? expected_a
    assert equal $? 0
  end

  it "adds an include? method which detects included items"
    # shellcheck disable=SC2034
    sample_a=( "a" "b" )
    Array.new sample_a
    sample_a.include? "b"
    assert equal $? 0
  end

  it "adds an index method"
    # shellcheck disable=SC2034
    sample_a=( "a" "b" )
    Array.new sample_a
    assert equal "$(sample_a.index "b")" "1"
  end

  it "adds the rest of the Array methods"
    # shellcheck disable=SC2034
    sample_a=( "a" "b" )
    Array.new sample_a
    # shellcheck disable=SC2034
    result_s="$(sample_a.join "a")"
    result_a=( $(sample_a.remove "a") )
    result_a=( $(sample_a.slice 1 1 ) )
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
