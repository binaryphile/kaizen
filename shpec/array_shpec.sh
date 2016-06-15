#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="$PWD"
_lib_dir="$_shpec_dir"/../lib
source "$_lib_dir"/core.sh
export BASH_PATH="$_lib_dir"

require "array"

describe "Array.include?"
  it "tests for element membership"
    letters=( a b c )
    Array.include? "a" "${letters[@]}"
    assert equal "$?" 0
  end
end

describe "Array.index"
  it "finds the index of the first element on exact match"
    letters=( a b c )
    assert equal "$(Array.index "a" "${letters[@]}")" 0
  end

  it "finds the index of the second element on exact match"
    letters=( a b c )
    assert equal "$(Array.index "b" "${letters[@]}")" 1
  end
end

describe "Array.join"
  it "joins array elements"
    array=( "a" "b" "c" )
    assert equal "$(Array.join "|" "${array[@]}")" "a|b|c"
  end

  it "allows a multicharacter delimiter"
    array=( "a" "b" "c" )
    assert equal "$(Array.join " | " "${array[@]}")" "a | b | c"
  end
end

describe "Array.remove"
  it "removes the last element of an array on exact match"
    letters=( "a" "b" "c" )
    result=( $(Array.remove "c" "${letters[@]}") )
    target=( "a" "b" )
    assert equal "${result[*]}" "${target[*]}"
  end

  it "doesn't remove elements which aren't there"
    letters=( "a" "b" "c" )
    result=( $(Array.remove "d" "${letters[@]}") )
    target=( "a" "b" "c" )
    assert equal "${result[*]}" "${target[*]}"
  end
end

describe "Array.slice"
  it "returns the middle slice"
    letters=( "a" "b" "c" )
    result=( $(Array.slice letters 1 1) )
    target=( "b" )
    assert equal "${result[*]}" "${target[*]}"
  end
end
