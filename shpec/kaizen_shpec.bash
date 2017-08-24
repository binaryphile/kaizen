set -o nounset

source concorde.bash
$(require_relative ../lib/kaizen)

$(grab '(
  ln
  mktempd
  rmdir
  rmtree
)' fromns concorde.macros)

describe append_to_file
  it "makes a new file"
    dir=$($mktempd)
    directory? "$dir" || return
    append_to_file "$dir"/file hello
    assert equal hello "$(< "$dir"/file )"
    $rmtree "$dir"
  end

  it "appends to an existing file"
    dir=$($mktempd)
    directory? "$dir" || return
    echo -n 'hello ' >"$dir"/file
    append_to_file "$dir"/file there
    assert equal 'hello there' "$(< "$dir"/file )"
    $rmtree "$dir"
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
  it "identifies a directory"
    dir=$($mktempd)
    directory? "$dir"
    assert equal 0 $?
    $rmdir "$dir"
  end

  it "identifies a symlink to a directory"
    dir=$($mktempd)
    directory? "$dir" || return
    $ln . "$dir"/dirlink
    directory? "$dir"/dirlink
    assert equal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify a symlink to a file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    $ln file "$dir"/filelink
    directory? "$dir"/filelink
    assert unequal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify a file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    directory? "$dir"/file
    assert unequal 0 $?
    $rmtree "$dir"
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
  it "identifies an executable file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    chmod 755 "$dir"/file
    executable? "$dir"/file
    assert equal 0 $?
    $rmtree "$dir"
  end

  it "identifies an executable directory"
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    chmod 755 "$dir"/dir
    executable? "$dir"/dir
    assert equal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify an non-executable file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    executable? "$dir"/file
    assert unequal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify a non-executable directory"
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    chmod 664 "$dir"/dir
    executable? "$dir"/dir
    assert unequal 0 $?
    $rmtree "$dir"
  end

  it "identifies a link to an executable file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    chmod 755 "$dir"/file
    $ln file "$dir"/link
    executable? "$dir"/link
    assert equal 0 $?
    $rmtree "$dir"
  end

  it "identifies a link to an executable directory"
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    chmod 755 "$dir"/dir
    $ln dir "$dir"/link
    executable? "$dir"/link
    assert equal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify a link to a non-executable file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    $ln file "$dir"/link
    executable? "$dir"/link
    assert unequal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify a link to a non-executable directory"
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    chmod 664 "$dir"/dir
    $ln dir "$dir"/link
    executable? "$dir"/link
    assert unequal 0 $?
    $rmtree "$dir"
  end
end

describe executable_file?
  it "identifies an executable file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    chmod 755 "$dir"/file
    executable_file? "$dir"/file
    assert equal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify an executable directory"
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    chmod 755 "$dir"/dir
    executable_file? "$dir"/dir
    assert unequal 0 $?
    $rmtree "$dir"
  end
end

describe file?
  it "identifies a file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    file? "$dir"/file
    assert equal 0 $?
    $rmtree "$dir"
  end

  it "identifies a symlink to a file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    $ln file "$dir"/filelink
    file? "$dir"/filelink
    assert equal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify a symlink to a directory"
    dir=$($mktempd)
    directory? "$dir" || return
    $ln . "$dir"/dirlink
    file? "$dir"/dirlink
    assert unequal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify a directory"
    dir=$($mktempd)
    directory? "$dir" || return
    file? "$dir"
    assert unequal 0 $?
    $rmdir "$dir"
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

describe nonexecutable_file?
  it "identifies a nonexecutable file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    nonexecutable_file? "$dir"/file
    assert equal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify an executable file"
    dir=$($mktempd)
    directory? "$dir" || return
    touch "$dir"/file
    chmod 755 "$dir"/file
    nonexecutable_file? "$dir"/file
    assert unequal 0 $?
    $rmtree "$dir"
  end

  it "doesn't identify a directory"
    dir=$($mktempd)
    directory? "$dir" || return
    mkdir "$dir"/dir
    nonexecutable_file? "$dir"/dir
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
