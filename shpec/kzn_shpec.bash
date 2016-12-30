source kzn.bash

library=../lib/shpec-helper.bash
source "${BASH_SOURCE%/*}/$library" 2>/dev/null || source "$library"
unset -v library

initialize_shpec_helper

describe 'absolute_path'
  it 'determines the path of a directory from the parent'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    # shellcheck disable=SC2154
    $mkdir mydir
    assert equal "$dir"/mydir "$(absolute_path mydir)"
    # shellcheck disable=SC2154
    $rm "$dir"
  end

  it 'determines the path of a file from the parent'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    $mkdir mydir
    # shellcheck disable=SC2154
    touch mydir/myfile
    assert equal "$dir"/mydir/myfile "$(absolute_path mydir/myfile)"
    # shellcheck disable=SC2154
    $rm "$dir"
  end

  it 'determines the path of a directory from itself'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    assert equal "$dir" "$(absolute_path .)"
    # shellcheck disable=SC2154
    $rm "$dir"
  end

  it 'determines the path of a file from the itself'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    touch myfile
    assert equal "$dir"/myfile "$(absolute_path myfile)"
    # shellcheck disable=SC2154
    $rm "$dir"
  end

  it 'determines the path of a directory from a sibling'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    $mkdir mydir1
    $mkdir mydir2
    cd mydir2
    # shellcheck disable=SC2154
    assert equal "$dir"/mydir1 "$(absolute_path ../mydir1)"
    # shellcheck disable=SC2154
    $rm "$dir"
  end

  it 'determines the path of a file from a sibling'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    $mkdir mydir1
    $mkdir mydir2
    # shellcheck disable=SC2154
    touch mydir1/myfile
    cd mydir2
    assert equal "$dir"/mydir1/myfile "$(absolute_path ../mydir1/myfile)"
    # shellcheck disable=SC2154
    $rm "$dir"
  end

  it 'determines the path of a directory from a child'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    $mkdir mydir
    cd mydir
    assert equal "$dir" "$(absolute_path ..)"
    # shellcheck disable=SC2154
    $rm "$dir"
  end

  it 'determines the path of a file from a child'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    $mkdir mydir
    touch myfile
    cd mydir
    assert equal "$dir"/myfile "$(absolute_path ../myfile)"
    # shellcheck disable=SC2154
    $rm "$dir"
  end

  it 'fails on a nonexistent path'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    absolute_path "$dir"/myfile >/dev/null
    assert unequal 0 $?
    # shellcheck disable=SC2154
    $rm "$dir"
  end
end

describe 'basename'
  it 'returns everything past the last slash'
    assert equal name "$(basename /my/name)"
  end
end

describe 'defa'
  it 'strips each line of a heredoc and assigns each to an element of an array'
    unset -v results
    # shellcheck disable=SC1041,SC1042,SC1073
    defa results <<'EOS'
      one
      two
      three
EOS
    expected='declare -a results=%s([0]="one" [1]="two" [2]="three")%s'
    # shellcheck disable=SC2059
    printf -v expected "$expected" \' \'
    # shellcheck disable=SC2154
    assert equal "$expected" "$(declare -p results)"
  end
end

describe 'defs'
  it 'strips each line of a heredoc and assigns to a string'
    defs result <<'EOS'
      one
      two
      three
EOS
    expected='declare -- result="one\ntwo\nthree"'
    # shellcheck disable=SC2059
    printf -v expected "$expected"
    # shellcheck disable=SC2154
    assert equal "$expected" "$(declare -p result)"
  end

  it 'leaves a blank line intact'
    defs result <<'EOS'
      one
      two

      four
EOS
    expected='declare -- result="one\ntwo\n\nfour"'
    # shellcheck disable=SC2059
    printf -v expected "$expected"
    # shellcheck disable=SC2034
    assert equal "$expected" "$(declare -p result)"
  end
end

describe 'dirname'
  it 'finds the directory name'
    assert equal one/two "$(dirname one/two/three)"
  end

  it 'finds the directory name with trailing slash'
    assert equal one/two "$(dirname one/two/three/)"
  end

  it 'finds the directory name without slash'
    assert equal . "$(dirname one)"
  end
end

describe 'geta'
  it 'assigns each line of an input to an element of an array'
    unset -v results
    # shellcheck disable=SC1041,SC1042,SC1073
    geta results <<'EOS'
      zero
      one
      two
EOS
    expected='declare -a results=%s([0]="      zero" [1]="      one" [2]="      two")%s'
    # shellcheck disable=SC2059
    printf -v expected "$expected" \' \'
    # shellcheck disable=SC2154
    assert equal "$expected" "$(declare -p results)"
  end

  it 'preserves a blank line'
    unset -v results
    # shellcheck disable=SC1041,SC1042,SC1073
    geta results <<'EOS'
      zero
      one

      three
EOS
    expected='declare -a results=%s([0]="      zero" [1]="      one" [2]="" [3]="      three")%s'
    # shellcheck disable=SC2059
    printf -v expected "$expected" \' \'
    # shellcheck disable=SC2154
    assert equal "$expected" "$(declare -p results)"
  end
end

describe 'is_directory'
  it 'identifies a directory'
    dir=$($mktempd)
    validate_dirname "$dir" || return
    is_directory "$dir"
    assert equal 0 $?
    cleanup "$dir"
  end

  it 'identifies a symlink to a directory'
    dir=$($mktempd)
    validate_dirname "$dir" || return
    # shellcheck disable=SC2154
    $ln . "$dir"/dirlink
    is_directory "$dir"/dirlink
    assert equal 0 $?
    cleanup "$dir"
  end

  it "doesn't identify a symlink to a file"
    dir=$($mktempd)
    validate_dirname "$dir" || return
    touch "$dir"/file
    # shellcheck disable=SC2154
    $ln file "$dir"/filelink
    is_directory "$dir"/filelink
    assert unequal 0 $?
    cleanup "$dir"
  end

  it "doesn't identify a file"
    dir=$($mktempd)
    validate_dirname "$dir" || return
    touch "$dir"/file
    is_directory "$dir"/file
    assert unequal 0 $?
    cleanup "$dir"
  end
end

describe 'is_executable'
  it 'identifies an executable file'
    dir=$($mktempd)
    validate_dirname "$dir" || return
    touch "$dir"/file
    chmod 755 "$dir"/file
    is_executable "$dir"/file
    assert equal 0 $?
    cleanup "$dir"
  end

  it 'identifies an executable directory'
    dir=$($mktempd)
    validate_dirname "$dir" || return
    mkdir "$dir"/dir
    chmod 755 "$dir"/dir
    is_executable "$dir"/dir
    assert equal 0 $?
    cleanup "$dir"
  end

  it "doesn't identify an non-executable file"
    dir=$($mktempd)
    validate_dirname "$dir" || return
    touch "$dir"/file
    is_executable "$dir"/file
    assert unequal 0 $?
    cleanup "$dir"
  end

  it "doesn't identify a non-executable directory"
    dir=$($mktempd)
    validate_dirname "$dir" || return
    mkdir "$dir"/dir
    chmod 664 "$dir"/dir
    is_executable "$dir"/dir
    assert unequal 0 $?
    cleanup "$dir"
  end

  it 'identifies a link to an executable file'
    dir=$($mktempd)
    validate_dirname "$dir" || return
    touch "$dir"/file
    chmod 755 "$dir"/file
    # shellcheck disable=SC2154
    $ln file "$dir"/link
    is_executable "$dir"/link
    assert equal 0 $?
    cleanup "$dir"
  end

  it 'identifies a link to an executable directory'
    dir=$($mktempd)
    validate_dirname "$dir" || return
    mkdir "$dir"/dir
    chmod 755 "$dir"/dir
    # shellcheck disable=SC2154
    $ln dir "$dir"/link
    is_executable "$dir"/link
    assert equal 0 $?
    cleanup "$dir"
  end

  it "doesn't identify a link to a non-executable file"
    dir=$($mktempd)
    validate_dirname "$dir" || return
    touch "$dir"/file
    # shellcheck disable=SC2154
    $ln file "$dir"/link
    is_executable "$dir"/link
    assert unequal 0 $?
    cleanup "$dir"
  end

  it "doesn't identify a link to a non-executable directory"
    dir=$($mktempd)
    validate_dirname "$dir" || return
    mkdir "$dir"/dir
    chmod 664 "$dir"/dir
    # shellcheck disable=SC2154
    $ln dir "$dir"/link
    is_executable "$dir"/link
    assert unequal 0 $?
    cleanup "$dir"
  end
end

describe 'is_file'
  it 'identifies a file'
    dir=$($mktempd)
    validate_dirname "$dir" || return
    touch "$dir"/file
    is_file "$dir"/file
    assert equal 0 $?
    cleanup "$dir"
  end

  it 'identifies a symlink to a file'
    dir=$($mktempd)
    validate_dirname "$dir" || return
    touch "$dir"/file
    # shellcheck disable=SC2154
    $ln file "$dir"/filelink
    is_file "$dir"/filelink
    assert equal 0 $?
    cleanup "$dir"
  end

  it "doesn't identify a symlink to a directory"
    dir=$($mktempd)
    validate_dirname "$dir" || return
    # shellcheck disable=SC2154
    $ln . "$dir"/dirlink
    is_file "$dir"/dirlink
    assert unequal 0 $?
    cleanup "$dir"
  end

  it "doesn't identify a directory"
    dir=$($mktempd)
    validate_dirname "$dir" || return
    is_file "$dir"
    assert unequal 0 $?
    cleanup "$dir"
  end
end

describe 'is_given'
  it 'detects an unset variable'
    unset -v dummy
    is_given "$dummy"
    assert unequal 0 $?
  end

  it 'detects an empty variable'; (
    dummy=''
    is_given "$dummy"
    assert unequal 0 $?
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end

  it 'detects a set variable'; (
    variable=value
    is_given "$variable"
    assert equal 0 $?
    return "$_shpec_failures" )
  end
end

describe 'is_same_as'
  it 'detects equivalent strings'
    is_same_as one one
    assert equal 0 $?
  end

  it 'detects non-equivalent strings'
    is_same_as one two
    assert unequal 0 $?
  end
end

describe 'is_set'
  it 'returns true if a variable is set'
    sample=true
    is_set sample
    assert equal 0 $?
  end

  it 'returns true if a variable is set to empty'
    # shellcheck disable=SC2034
    sample=''
    is_set sample
    assert equal 0 $?
  end

  it 'returns false if a variable is not set'
    unset -v sample
    is_set sample
    assert unequal 0 $?
  end
end

describe 'is_symlink'
  it "doesn't identify a file"
    dir=$($mktempd)
    validate_dirname "$dir" || return
    touch "$dir"/file
    is_symlink "$dir"/file
    assert unequal 0 $?
    cleanup "$dir"
  end

  it 'identifies a symlink to a file'
    dir=$($mktempd)
    validate_dirname "$dir" || return
    touch "$dir"/file
    # shellcheck disable=SC2154
    $ln file "$dir"/filelink
    is_symlink "$dir"/filelink
    assert equal 0 $?
    cleanup "$dir"
  end

  it 'identifies a symlink to a directory'
    dir=$($mktempd)
    validate_dirname "$dir" || return
    # shellcheck disable=SC2154
    $ln . "$dir"/dirlink
    is_symlink "$dir"/dirlink
    assert equal 0 $?
    cleanup "$dir"
  end

  it "doesn't identify a directory"
    dir=$($mktempd)
    validate_dirname "$dir" || return
    is_symlink "$dir"
    assert unequal 0 $?
    cleanup "$dir"
  end
end

describe 'puts'
  it 'outputs a string on stdout'
    assert equal sample "$(puts 'sample')"
  end
end

describe 'putserr'
  it 'outputs a string on stderr'
    assert equal sample "$(putserr 'sample' 2>&1)"
  end
end

describe 'splits'
  it 'splits a string into an array on a partition character'
    # shellcheck disable=SC2034
    sample='a=b'
    printf -v expected 'declare -a results=%s([0]="a" [1]="b")%s' \' \'
    assert equal "$expected" "$(splits '=' sample)"
  end
end

describe 'starts_with'
  it 'detects if a string starts with a specified character'
    starts_with / /test
    assert equal 0 $?
  end

  it "detects if a string doesn't end with a specified character"
    starts_with / test
    assert unequal 0 $?
  end
end

describe 'stripa'
  it 'strips each element of an array'
    # shellcheck disable=SC2034
    results=("    zero" "    one" "    two")
    stripa results
    expected='declare -a results=%s([0]="zero" [1]="one" [2]="two")%s'
    # shellcheck disable=SC2059
    printf -v expected "$expected" \' \'
    # shellcheck disable=SC2154,SC2034
    assert equal "$expected" "$(declare -p results)"
  end

  it 'leaves a blank element intact'
    results=("    zero" "    one"  "" "    three")
    stripa results
    expected='declare -a results=%s([0]="zero" [1]="one" [2]="" [3]="three")%s'
    # shellcheck disable=SC2059
    printf -v expected "$expected" \' \'
    # shellcheck disable=SC2154,SC2034
    assert equal "$expected" "$(declare -p results)"
  end
end

describe 'to_lower'
  it 'should lower-case a string'
    assert equal upper "$(to_lower UPPER)"
  end
end

describe 'to_upper'
  it 'should upper-case a string'
    assert equal LOWER "$(to_upper lower)"
  end
end
