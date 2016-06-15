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

describe "Array.new"
  it "adds an include? method"
    # shellcheck disable=SC2034
    sample_a=( "" )
    Array.new sample_a
    sample_a.include? "a"
    assert equal $? 1
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

  # it "adds a eql? method which detects inequality"
  #   # shellcheck disable=SC2034
  #   sample_s="a"
  #   String.new sample_s
  #   sample_s.eql? "b"
  #   assert equal $? 1
  # end
  #
  # it "adds the rest of the String methods"
  #   # shellcheck disable=SC2034
  #   sample_s="a"
  #   String.new sample_s
  #   # shellcheck disable=SC2034
  #   result="$(sample_s.split)"
  #   sample_s.exit_if_blank?
  #   assert equal $? 0
  # end
end
