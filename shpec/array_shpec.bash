set -o nounset

source "$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")"/../lib/array.bash

describe ary_join
  it "joins array elements"; ( _shpec_failures=0
    array=( a b c )
    result=$(ary_join '|' "${array[@]}")
    assert equal 'a|b|c' "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "allows a multicharacter delimiter"; ( _shpec_failures=0
    array=( a b c )
    result=$(ary_join ' | ' "${array[@]}")
    assert equal 'a | b | c' "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end

describe ary_contains
  it "tests for element membership"; ( _shpec_failures=0
    letters=( a b c )
    ary_contains a "${letters[@]}"
    assert equal 0 $?
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end

describe ary_find
  it "finds the index of the first element on exact match"; ( _shpec_failures=0
    letters=( a b c )
    result=$(ary_find a "${letters[@]}")
    assert equal 0 "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "finds the index of the second element on exact match"; ( _shpec_failures=0
    letters=( a b c )
    result=$(ary_find b "${letters[@]}")
    assert equal 1 "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end

describe ary_remove
it "removes the last element of an array on exact match"; ( _shpec_failures=0
    letters=( a b c )
    result=( $(ary_remove c "${letters[@]}") )
    target=( a b )
    assert equal "${result[*]}" "${target[*]}"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "doesn't remove elements which aren't there"; ( _shpec_failures=0
    letters=( a b c )
    result=( $(ary_remove d "${letters[@]}") )
    target=( a b c )
    assert equal "${result[*]}" "${target[*]}"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end

describe ary_slice
  it "returns the middle slice"; ( _shpec_failures=0
    letters=( a b c )
    result=( $(ary_slice 1 1 "${letters[@]}") )
    target=( b )
    assert equal "${result[*]}" "${target[*]}"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end
