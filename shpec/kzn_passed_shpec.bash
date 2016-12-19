source kzn.bash
initialize_kzn

library=../lib/shpec_helper.bash
source "${BASH_SOURCE%/*}/$library" 2>/dev/null || source "$library"
unset -v library

initialize_shpec_helper

describe 'passed'
  it 'creates a scalar declaration from an array naming a single parameter with the value passed after'
    set -- 0
    args=( zero ) # shellcheck disable=SC2034
    assert equal 'declare zero=0' "$(eval 'passed args "$@"')"
  end

  it 'works for two arguments'
    set -- 0 1
    args=( zero one ) # shellcheck disable=SC2034
    assert equal 'declare zero=0;declare one=1' "$(eval 'passed args "$@"')"
  end

  it 'creates an array declaration from a special syntax'
    values=( zero one ) # shellcheck disable=SC2034
    set -- values
    args=( @array ) # shellcheck disable=SC2034
    assert equal 'declare -a array='\''([0]="zero" [1]="one")'\' "$(eval 'passed args "$@"')"
  end

  it 'creates a hash declaration from a special syntax'
    # shellcheck disable=SC2034
    declare -A values=( [zero]=0 [one]=1 )
    set -- values
    args=( %hash ) # shellcheck disable=SC2034
    assert equal 'declare -A hash='\''([one]="1" [zero]="0" )'\' "$(eval 'passed args "$@"')"
  end

  it 'accepts an array literal'
    set -- '[0]="zero" [1]="one"'
    args=( @array ) # shellcheck disable=SC2034
    assert equal 'declare -a array='\''([0]="zero" [1]="one")'\' "$(eval 'passed args "$@"')"
  end

  it 'accepts a hash literal'
    set -- '[zero]="0" [one]="1"'
    args=( %hash ) # shellcheck disable=SC2034
    assert equal 'declare -A hash='\''([zero]="0" [one]="1")'\' "$(eval 'passed args "$@"')"
  end
end
