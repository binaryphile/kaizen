set -o nounset

source concorde.bash
$(require_relative ../lib/kaizen)

$(grab '
  ln
  mktempd
  rmdir
  rmtree
' fromns concorde.macros)

describe append_to_file
  it "makes a new file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    append_to_file "$dir"/file hello
    assert equal hello "$(< "$dir"/file )"
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "appends to an existing file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    echo -n 'hello ' >"$dir"/file
    append_to_file "$dir"/file there
    assert equal 'hello there' "$(< "$dir"/file )"
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe args?
  it "detects no arguments"; ( _shpec_failures=0
    args?
    assert unequal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "detects one argument"; ( _shpec_failures=0
    args? one
    assert equal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "detects two arguments"; ( _shpec_failures=0
    args? one two
    assert equal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe contains?
  it "identifies a character in a string"; ( _shpec_failures=0
    contains? / one/two
    assert equal $? 0
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify a missing character in a string"; ( _shpec_failures=0
    contains? / one_two
    assert equal $? 1
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify a character in an empty string"; ( _shpec_failures=0
    contains? / ''
    assert equal $? 1
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe directory?
  it "identifies a directory"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir"
    assert equal 0 $?
    $rmdir "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "identifies a symlink to a directory"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    $ln . "$dir"/dirlink
    directory? "$dir"/dirlink
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify a symlink to a file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    $ln file "$dir"/filelink
    directory? "$dir"/filelink
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify a file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    directory? "$dir"/file
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe ends_with?
  it "detects if a string ends with a specified character"; ( _shpec_failures=0
    ends_with? / test/
    assert equal $? 0
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "detects if a string doesn't end with a specified character"; ( _shpec_failures=0
    ends_with? / test
    assert equal $? 1
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe executable?
  it "identifies an executable file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    chmod 755 "$dir"/file
    executable? "$dir"/file
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "identifies an executable directory"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    chmod 755 "$dir"/dir
    executable? "$dir"/dir
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify an non-executable file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    executable? "$dir"/file
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify a non-executable directory"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    chmod 664 "$dir"/dir
    executable? "$dir"/dir
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "identifies a link to an executable file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    chmod 755 "$dir"/file
    $ln file "$dir"/link
    executable? "$dir"/link
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "identifies a link to an executable directory"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    chmod 755 "$dir"/dir
    $ln dir "$dir"/link
    executable? "$dir"/link
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify a link to a non-executable file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    $ln file "$dir"/link
    executable? "$dir"/link
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify a link to a non-executable directory"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    chmod 664 "$dir"/dir
    $ln dir "$dir"/link
    executable? "$dir"/link
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe executable_file?
  it "identifies an executable file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    chmod 755 "$dir"/file
    executable_file? "$dir"/file
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify an executable directory"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    chmod 755 "$dir"/dir
    executable_file? "$dir"/dir
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe false?
  it "doesn't detect a reference to a positive value"; ( _shpec_failures=0
    sample=1
    false? sample
    assert unequal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "detects a reference to a non-positive value"; ( _shpec_failures=0
    sample=0
    false? sample
    assert equal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "detects an unset reference"; ( _shpec_failures=0
    sample=''
    unset -v sample
    false? sample
    assert equal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe file?
  it "identifies a file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    file? "$dir"/file
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "identifies a symlink to a file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    $ln file "$dir"/filelink
    file? "$dir"/filelink
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify a symlink to a directory"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    $ln . "$dir"/dirlink
    file? "$dir"/dirlink
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify a directory"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    file? "$dir"
    assert unequal 0 $?
    $rmdir "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe given?
  it "detects a non-empty value"; ( _shpec_failures=0
    sample=one
    given? sample
    assert equal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't detect an empty value"; ( _shpec_failures=0
    sample=''
    given? sample
    assert unequal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't detect an unset value"; ( _shpec_failures=0
    sample=''
    unset -v sample
    given? sample
    assert unequal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe glob
  it "expands a glob"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    cd "$dir"
    touch file1
    glob *
    eval "declare -a result_ary=( $__ )"
    assert equal file1 "$result_ary"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "expands a glob with multiple entries"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    cd "$dir"
    touch file1
    touch file2
    glob *
    eval "declare -a result_ary=( $__ )"
    assert equal '(file1) (file2)' "(${result_ary[0]}) (${result_ary[1]})"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "expands a glob with a space"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    cd "$dir"
    touch 'file 1'
    glob *
    eval "declare -a result_ary=( $__ )"
    assert equal 'file 1' "${result_ary[0]}"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't split a non-glob with a space"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    cd "$dir"
    touch 'file 1'
    glob '"file 1"'
    eval "declare -a result_ary=( $__ )"
    assert equal 'file 1' "${result_ary[0]}"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "preserves glob_mode when off"; ( _shpec_failures=0
    glob_mode off
    glob *
    glob_mode status
    assert equal off "$__"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "preserves glob_mode when on"; ( _shpec_failures=0
    glob_mode on
    glob *
    glob_mode status
    assert equal on "$__"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe glob_mode
  it "turns of globbing"; ( _shpec_failures=0
    glob_mode on
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    result1=$( echo "$dir"/* )
    glob_mode off
    result2=$( echo "$dir"/* )
    assert equal "($dir/file) ($dir/*)" "($result1) ($result2)"
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "turns on globbing"; ( _shpec_failures=0
    glob_mode off
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    result1=$( echo "$dir"/* )
    glob_mode on
    result2=$( echo "$dir"/* )
    assert equal "($dir/*) ($dir/file)" "($result1) ($result2)"
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "reports status on"; ( _shpec_failures=0
    glob_mode on
    glob_mode status
    assert equal on "$__"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "reports status on"; ( _shpec_failures=0
    glob_mode off
    glob_mode status
    assert equal off "$__"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe less_than?
  it "should identify numbers of arguments less than specified"; ( _shpec_failures=0
    less_than? 2 one
    assert equal $? 0
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "shouldn't identify numbers of arguments not less than specified"; ( _shpec_failures=0
    less_than? 2 one two
    assert equal $? 1
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe more_than?
  it "should identify numbers of arguments greater than specified"; ( _shpec_failures=0
    more_than? 2 one two three
    assert equal $? 0
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "shouldn't identify numbers of arguments not greater than specified"; ( _shpec_failures=0
    more_than? 2 one two
    assert equal $? 1
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe nonexecutable_file?
  it "identifies a nonexecutable file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    nonexecutable_file? "$dir"/file
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify an executable file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    chmod 755 "$dir"/file
    nonexecutable_file? "$dir"/file
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't identify a directory"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    nonexecutable_file? "$dir"/dir
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe symlink?
  it "doesn't identify a file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    symlink? "$dir"/file
    assert unequal 0 $?
    $rmtree "$dir"
  end

  it "identifies a symlink to a file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    $ln file "$dir"/filelink
    symlink? "$dir"/filelink
    assert equal 0 $?
    $rmtree "$dir"
  end

  it "identifies a symlink to a directory"
    dir=$($mktempd)
    directory? "$dir" || return
    $ln . "$dir"/dirlink
    symlink? "$dir"/dirlink
    assert equal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify a directory"
    dir=$($mktempd)
    directory? "$dir" || return
    symlink? "$dir"
    assert unequal 0 $?
    $rmtree "$dir"
  end
end

describe trim_from_last
  it "trims from the last single-character specifier"; ( _shpec_failures=0
    trim_from_last e stereo
    assert equal ster "$__"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "trims a multicharacter specifier"; ( _shpec_failures=0
    trim_from_last el hello
    assert equal h "$__"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "trims nothing if the specifier isn't present"; ( _shpec_failures=0
    trim_from_last a hello
    assert equal hello "$__"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe trim_to_last
  it "trims up to the last single character specifier"; ( _shpec_failures=0
    trim_to_last e stereo
    assert equal o "$__"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "trims a multicharacter specifier"; ( _shpec_failures=0
    trim_to_last el hello
    assert equal lo "$__"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "trims nothing if the specifier isn't present"; ( _shpec_failures=0
    trim_to_last a hello
    assert equal hello "$__"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe true?
  it "detects a reference to a positive value"; ( _shpec_failures=0
    sample=1
    true? sample
    assert equal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't detect a reference to a non-positive value"; ( _shpec_failures=0
    sample=0
    true? sample
    assert unequal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "doesn't detect an unset reference"; ( _shpec_failures=0
    sample=''
    unset -v sample
    true? sample
    assert unequal 0 $?
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end

describe write_to_file
  it "makes a new file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    write_to_file "$dir"/file hello
    assert equal hello "$(< "$dir"/file )"
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end

  it "overwrites an existing file"; ( _shpec_failures=0
    dir=$($mktempd)
    directory? "$dir" || return
    echo -n 'hello ' >"$dir"/file
    write_to_file "$dir"/file there
    assert equal there "$(< "$dir"/file )"
    $rmtree "$dir"
    return "$_shpec_failures" ); : $(( _shpec_failures += $? ))
  end
end
