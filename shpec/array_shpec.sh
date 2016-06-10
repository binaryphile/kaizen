#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="${PWD}"

source "$_shpec_dir"/../lib/array.sh

describe "ary.include?"
  it "tests for element membership"
    letters=( a b c )
    ary.include? "a" "${letters[@]}"
    assert equal "$?" 0
  end
end

describe "ary.index"
  it "finds the index of the first element on exact match"
    letters=( a b c )
    assert equal "$(ary.index "a" "${letters[@]}")" 0
  end

  it "finds the index of the second element on exact match"
    letters=( a b c )
    assert equal "$(ary.index "b" "${letters[@]}")" 1
  end
end

describe "ary.join"
  it "joins array elements"
    array=( "a" "b" "c" )
    assert equal "$(ary.join "|" "${array[@]}")" "a|b|c"
  end

  it "allows a multicharacter delimiter"
    array=( "a" "b" "c" )
    assert equal "$(ary.join " | " "${array[@]}")" "a | b | c"
  end
end

describe "ary.new"
  it "creates a new copy of an array"
    local array=( "a" "b" "c" )
    # shellcheck disable=SC2034
    local copy
    ary.new copy array
    assert equal "${copy[*]}" "a b c"
  end
end

describe "ary.remove"
  it "removes the last element of an array on exact match"
    letters=( "a" "b" "c" )
    result=( $(ary.remove "c" "${letters[@]}") )
    target=( "a" "b" )
    assert equal "${result[*]}" "${target[*]}"
  end

  it "doesn't remove elements which aren't there"
    letters=( "a" "b" "c" )
    result=( $(ary.remove "d" "${letters[@]}") )
    target=( "a" "b" "c" )
    assert equal "${result[*]}" "${target[*]}"
  end
end

describe "ary.slice"
  it "returns the middle slice"
    letters=( "a" "b" "c" )
    result=( $(ary.slice letters 1 1) )
    target=( "b" )
    assert equal "${result[*]}" "${target[*]}"
  end
end
