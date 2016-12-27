source kzn.bash

library=../lib/shpec-helper.bash
source "${BASH_SOURCE%/*}/$library" 2>/dev/null || source "$library"
unset -v library

initialize_shpec_helper

describe 'assign'
  it 'assigns an array result'
    unset -v resulta
    eval "$(assign resulta "$(printf 'declare -a sample=%s([0]="zero" [1]="one")%s' \' \')")"
    expected=$(printf 'declare -a resulta=%s([0]="zero" [1]="one")%s' \' \')
    # shellcheck disable=SC2034
    assert equal "$expected" "$(declare -p resulta)"
  end

  it 'assigns a hash result'
    unset -v resulth
    eval "$(assign resulth "$(printf 'declare -A sample=%s([one]="1" [zero]="0" )%s' \' \')")"
    expected=$(printf 'declare -A resulth=%s([one]="1" [zero]="0" )%s' \' \')
    # shellcheck disable=SC2034
    assert equal "$expected" "$(declare -p resulth)"
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

  it 'allows default values'
    set --
    params=( zero="one two" ) # shellcheck disable=SC2034
    assert equal 'declare -- zero="one two"' "$(passed params "$@")"
  end

  it 'creates a scalar declaration from a scalar reference'; (
    # shellcheck disable=SC2034
    var=0
    set -- var
    params=( zero ) # shellcheck disable=SC2034
    assert equal 'declare -- zero="0"' "$(passed params "$@")"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
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
    expected=$(printf 'declare -a array=%s([0]="%s"zero one%s"" [1]="two")%s' \' \\ \\ \')
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
    set -- '[0]="zero" [1]="one"'
    params=( @array ) # shellcheck disable=SC2034
    expected=$(printf 'declare -a array=%s([0]="zero" [1]="one")%s' \' \')
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'allows array default values'
    set --
    params=( @array='[0]="zero" [1]="one"' ) # shellcheck disable=SC2034
    expected=$(printf 'declare -a array=%s([0]="zero" [1]="one")%s' \' \' )
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'accepts a hash literal'
    set -- '[zero]="0" [one]="1"'
    params=( %hash ) # shellcheck disable=SC2034
    expected=$(printf 'declare -A hash=%s([zero]="0" [one]="1")%s' \' \' )
    assert equal "$expected" "$(passed params "$@")"
  end

  it 'allows hash default values'
    set --
    params=( %hash='[zero]="0" [one]="1"' ) # shellcheck disable=SC2034
    expected=$(printf 'declare -A hash=%s([zero]="0" [one]="1")%s' \' \')
    assert equal "$expected" "$(passed params "$@")"
  end
end
