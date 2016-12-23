source kzn.bash

library=../lib/shpec_helper.bash
source "${BASH_SOURCE%/*}/$library" 2>/dev/null || source "$library"
unset -v library

initialize_shpec_helper

describe 'instantiate'
  it 'works for one argument'; (
    set -- 1
    params=( one )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal 'declare one=1' "$result"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end

  it 'works for two arguments'; (
    set -- 1 2
    params=( one two )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal 'declare one=1 two=2' "$result"
    return "$_shpec_failures" )
  end

  it 'works with one argument from a hash'; (
    # shellcheck disable=SC2034
    declare -A args=( [one]=1 )
    set -- :args
    params=( one )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal 'declare one=1' "$result"
    return "$_shpec_failures" )
  end

  it 'works with one positional argument and one from a hash'; (
    # shellcheck disable=SC2034
    declare -A args=( [two]=2 )
    set -- 1 :args
    params=( one two )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal 'declare one=1 two=2' "$result"
    return "$_shpec_failures" )
  end

  it 'instantiates empty variables'; (
    # shellcheck disable=SC2034
    set -- ''
    params=( one )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "declare one=''" "$result"
    return "$_shpec_failures" )
  end

  it 'instantiates empty variables with a hash after'; (
    # shellcheck disable=SC2034
    declare -A args=( [two]=2 )
    set -- '' :args
    params=( one two )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "declare one='' two=2" "$result"
    return "$_shpec_failures" )
  end

  it 'instantiates empty variables from a hash'; (
    # shellcheck disable=SC2034
    declare -A args=( [one]="" [two]=2 )
    set -- :args
    params=( one two )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "declare one='' two=2" "$result"
    return "$_shpec_failures" )
  end

  it "works for an in-line named argument"; (
    set -- :one=1
    params=( one )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "declare one=1" "$result"
    return "$_shpec_failures" )
  end

  it "works for a hash"; (
    local -A args=( [one]=1 )
    set -- args
    params=( :hash )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    expected=$(printf 'declare -A hash=%s([one]="1" )%s' "'" "'")
    assert equal "$expected" "$result"
    return "$_shpec_failures" )
  end

  it "works for two hashes"; (
    local -A args1=( [one]=1 )
    local -A args2=( [two]=2 )
    set -- args1 args2
    params=( :hash1 :hash2 )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    expected=$(printf 'declare -A hash1=%s([one]="1" )%s;declare -A hash2=%s([two]="2" )%s' "'" "'" "'" "'")
    assert equal "$expected" "$result"
    return "$_shpec_failures" )
  end

  it "works for an argument and a hash"; (
    local -A args=( [two]=2 )
    set -- 1 args
    params=( one :hash )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    expected=$(printf 'declare one=1;declare -A hash=%s([two]="2" )%s' "'" "'")
    assert equal "$expected" "$result"
    return "$_shpec_failures" )
  end

  it "resolves in favor of positional arguments vs named keywords"; (
    # shellcheck disable=SC2034
    set -- 1 :one=fail
    params=( one )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "declare one=1" "$result"
    return "$_shpec_failures" )
  end

  it "resolves in favor of positional arguments vs hashes"; (
    # shellcheck disable=SC2034
    declare -A args=( [one]=override )
    set -- 1 :args
    params=( one )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "declare one=1" "$result"
    return "$_shpec_failures" )
  end

  it "resolves in favor of keyword arguments vs hashes"; (
    # shellcheck disable=SC2034
    declare -A args=( [one]=override )
    set -- :one=1 :args
    params=( one )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "declare one=1" "$result"
    return "$_shpec_failures" )
  end

  it "accepts all three forms"; (
    # shellcheck disable=SC2034
    declare -A args=( [three]=3 )
    set -- 1 :two=2 :args
    params=( one two three )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "declare one=1 two=2 three=3" "$result"
    return "$_shpec_failures" )
  end

  it "allows out of order definition in keyword and hash arguments"; (
    # shellcheck disable=SC2034
    declare -A args=( [one]=1 )
    # shellcheck disable=SC2034
    set -- :two=2 :args
    params=( one two )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "declare one=1 two=2" "$result"
    return "$_shpec_failures" )
  end

  it "resolves multiple overlapping hashes in order"; (
    # shellcheck disable=SC2034
    declare -A args1=( [one]=1 )
    # shellcheck disable=SC2034
    declare -A args2=( [one]=fail )
    # shellcheck disable=SC2034
    set -- :args1 :args2
    params=( one )
    result=$(instantiate "${#params[@]}" "${params[@]}" "$@")
    assert equal "declare one=1" "$result"
    return "$_shpec_failures" )
  end
end
