source kzn.bash

library=../lib/shpec-helper.bash
source "${BASH_SOURCE%/*}/$library" 2>/dev/null || source "$library"
unset -v library

initialize_shpec_helper

describe 'assign'
  it 'assigns an array result'
    printf -v sample    'declare -a sample=%s([0]="zero" [1]="one")%s' \' \'
    printf -v expected  'declare -a otherv=%s([0]="zero" [1]="one")%s' \' \'
    assert equal "$expected" "$(assign otherv "$sample")"
  end

  it 'assigns a hash result'
    printf -v sample    'declare -A sample=%s([one]="1" [zero]="0" )%s' \' \'
    printf -v expected  'declare -A otherv=%s([one]="1" [zero]="0" )%s' \' \'
    # shellcheck disable=SC2034
    assert equal "$expected" "$(assign otherv "$sample")"
  end
end

describe 'pass'
  it 'declares a variable'
    # shellcheck disable=SC2034
    sample=var
    assert equal 'declare -- sample="var"' "$(pass sample)"
  end
end

describe 'passed'
  it 'creates a scalar declaration from an array naming a single parameter with the value passed after'
    set -- 0
    params=( zero ) # shellcheck disable=SC2034
    assert equal 'declare -- zero="0"' "$(passed params "$@")"
  end

  it 'accepts empty values'
    set --
    params=( zero ) # shellcheck disable=SC2034
    assert equal 'declare -- zero=""' "$(passed params "$@")"
  end

  it 'allows default values'
    set --
    params=( zero="one two" ) # shellcheck disable=SC2034
    assert equal 'declare -- zero="one two"' "$(passed params "$@")"
  end

  it 'overrides default values with empty parameters'
    set -- ""
    params=( zero="one two" ) # shellcheck disable=SC2034
    assert equal 'declare -- zero=""' "$(passed params "$@")"
  end

  it 'creates a scalar declaration from a scalar reference'
    # shellcheck disable=SC2034
    sample=0
    set -- sample
    params=( zero ) # shellcheck disable=SC2034
    assert equal 'declare -- zero="0"' "$(passed params "$@")"
  end

  it 'creates a scalar declaration from an indexed array reference'
    # shellcheck disable=SC2034
    samples=( 0 )
    set -- samples[0]
    params=( zero ) # shellcheck disable=SC2034
    assert equal 'declare -- zero="0"' "$(passed params "$@")"
  end

  it 'errors on a scalar declaration from an unset value of an array reference'
    # shellcheck disable=SC2034
    samples=( 0 )
    set -- samples[1]
    params=( zero ) # shellcheck disable=SC2034
    passed params "$@" >/dev/null
    assert unequal 0 $?
  end

  it 'works for two arguments'
    set -- 0 1
    params=( zero one ) # shellcheck disable=SC2034
    assert equal 'declare -- zero="0";declare -- one="1"' "$(passed params "$@")"
  end

  it 'accepts strings with quotes'
    set -- 'string with "quotes"'
    params=( zero ) # shellcheck disable=SC2034
    assert equal 'declare -- zero="string with \"quotes\""' "$(passed params "$@")"
  end

  it 'creates an array declaration from a special syntax'
    values=( zero one ) # shellcheck disable=SC2034
    set -- values
    params=( @array ) # shellcheck disable=SC2034
    expected=$(printf 'declare -a array=%s([0]="zero" [1]="one")%s' \' \')
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'creates an array declaration with quotes'
    values=( '"zero one"' two ) # shellcheck disable=SC2034
    set -- values
    params=( @array ) # shellcheck disable=SC2034
    expected=$(printf 'declare -a array=%s([0]="\\"zero one\\"" [1]="two")%s' \' \')
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'creates a hash declaration from a special syntax'
    # shellcheck disable=SC2034
    declare -A values=( [zero]=0 [one]=1 )
    set -- values
    params=( %hash ) # shellcheck disable=SC2034
    expected=$(printf 'declare -A hash=%s([one]="1" [zero]="0" )%s' \' \')
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'creates a reference declaration from a special syntax'
    # shellcheck disable=SC2034
    set -- var
    params=( '&ref' ) # shellcheck disable=SC2034
    assert equal 'declare -n ref="var"' "$(passed params "$@")"
  end

  it 'accepts an array literal'
    set -- '([0]="zero" [1]="one")'
    params=( @array ) # shellcheck disable=SC2034
    expected=$(printf 'declare -a array=%s([0]="zero" [1]="one")%s' \' \')
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'accepts an array literal without indices'
    set -- '("zero" "one")'
    params=( @array ) # shellcheck disable=SC2034
    expected=$(printf 'declare -a array=%s([0]="zero" [1]="one")%s' \' \')
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'accepts an empty array literal'
    set -- '()'
    params=( @array ) # shellcheck disable=SC2034
    expected=$(printf 'declare -a array=%s()%s' \' \')
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'allows array default values'
    set --
    params=( @array='([0]="zero" [1]="one")' ) # shellcheck disable=SC2034
    expected=$(printf 'declare -a array=%s([0]="zero" [1]="one")%s' \' \' )
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'accepts a hash literal'
    set -- '([zero]="0" [one]="1")'
    params=( %hash ) # shellcheck disable=SC2034
    expected=$(printf 'declare -A hash=%s([one]="1" [zero]="0" )%s' \' \' )
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'accepts an empty hash literal'
    set -- '()'
    params=( %hash ) # shellcheck disable=SC2034
    expected=$(printf 'declare -A hash=%s()%s' \' \' )
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'allows hash default values'
    set --
    params=( %hash='([zero]="0" [one]="1")' ) # shellcheck disable=SC2034
    expected=$(printf 'declare -A hash=%s([one]="1" [zero]="0" )%s' \' \')
    assert equal "$expected" "$(passed params "$@")"
  end
end

describe 'fromh'
  it 'imports a hash key into the current scope'
    unset -v zero
    # shellcheck disable=SC2034
    declare -A sampleh=( [zero]=0 )
    assert equal 'declare -- zero="0"' "$(fromh sampleh)"
  end

  it 'imports a key with a space in its value'
    unset -v zero
    # shellcheck disable=SC2034
    declare -A sampleh=( [zero]="0 1" )
    assert equal 'declare -- zero="0 1"' "$(fromh sampleh)"
  end

  it 'imports only named keys'
    unset -v zero one
    # shellcheck disable=SC2034
    declare -A sampleh=( [zero]="0" [one]="1" )
    # shellcheck disable=SC2034
    params=( one )
    assert equal 'declare -- one="1"' "$(fromh sampleh params)"
  end
end
