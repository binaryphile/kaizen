source kzn.bash
initialize_kzn

library=../lib/shpec_helper.bash
source "${BASH_SOURCE%/*}/$library" 2>/dev/null || source "$library"
unset -v library

initialize_shpec_helper


describe "instantiate"
  it "works for one argument"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one )
    set -- 1
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=1" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "works for two arguments"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one two )
    set -- 1 2
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=1 two=2" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "works with one argument from a hash"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one )
    # shellcheck disable=SC2034
    declare -A args=( [one]=1 )
    set -- :args
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=1" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "works with one positional argument and one from a hash"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one two )
    # shellcheck disable=SC2034
    declare -A args=( [two]=2 )
    set -- 1 :args
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=1 two=2" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "instantiates empty variables"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one )
    # shellcheck disable=SC2034
    set --
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=''" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "works for an in-line named argument"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one )
    set -- :one=1
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=1" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "resolves in favor of positional arguments vs named keywords"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one )
    # shellcheck disable=SC2034
    set -- 1 :one=override
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=1" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "resolves in favor of positional arguments vs hashes"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one )
    # shellcheck disable=SC2034
    declare -A args=( [one]=override )
    set -- 1 :args
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=1" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "resolves in favor of keyword arguments vs hashes"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one )
    # shellcheck disable=SC2034
    declare -A args=( [one]=override )
    set -- :one=1 :args
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=1" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "accepts all three forms"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one two three )
    # shellcheck disable=SC2034
    declare -A args=( [three]=3 )
    set -- 1 :two=2 :args
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=1 two=2 three=3" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "allows out of order definition in keyword and hash arguments"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one two )
    # shellcheck disable=SC2034
    declare -A args=( [one]=1 )
    # shellcheck disable=SC2034
    set -- :two=2 :args
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=1 two=2" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "resolves multiple overlapping hashes in order"; ( _shpec_failures=0   # shellcheck disable=SC2030

    local params=( one )
    # shellcheck disable=SC2034
    declare -A args1=( [one]=1 )
    # shellcheck disable=SC2034
    declare -A args2=( [one]=override )
    # shellcheck disable=SC2034
    set -- :args1 :args2
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "local one=1" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
