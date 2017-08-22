source concorde.bash
$(grab '(
  ln
  mktempd
  rmdir
  rmtree
)' fromns concorde.macros)
$(require_relative ../lib/kaizen)

set -o nounset

# describe 'absolute_path'
#   it "determines the path of a directory from the parent"; ( _shpec_failures=0
#     dir=$($mktempd) || return
#     cd "$dir"
#     $mkdir mydir
#     assert equal "$dir"/mydir "$(absolute_path mydir)"
#     $rmtree "$dir"
#     return "$_shpec_failures" ); : $(( _shpec_failures += $? )) ||:
#   end
#
#   # it "determines the path of a file from the parent"
#   #   dir=$($mktempd) || return 1
#   #   cd "$dir"
#   #   $mkdir mydir
#   #   touch mydir/myfile
#   #   assert equal "$dir"/mydir/myfile "$(absolute_path mydir/myfile)"
#   #   $rm "$dir"
#   # end
#   #
#   # it "determines the path of a directory from itself"
#   #   dir=$($mktempd) || return 1
#   #   cd "$dir"
#   #   assert equal "$dir" "$(absolute_path .)"
#   #   $rm "$dir"
#   # end
#   #
#   # it "determines the path of a file from the itself"
#   #   dir=$($mktempd) || return 1
#   #   cd "$dir"
#   #   touch myfile
#   #   assert equal "$dir"/myfile "$(absolute_path myfile)"
#   #   $rm "$dir"
#   # end
#   #
#   # it "determines the path of a directory from a sibling"
#   #   dir=$($mktempd) || return 1
#   #   cd "$dir"
#   #   $mkdir mydir1
#   #   $mkdir mydir2
#   #   cd mydir2
#   #   assert equal "$dir"/mydir1 "$(absolute_path ../mydir1)"
#   #   $rm "$dir"
#   # end
#   #
#   # it "determines the path of a file from a sibling"
#   #   dir=$($mktempd) || return 1
#   #   cd "$dir"
#   #   $mkdir mydir1
#   #   $mkdir mydir2
#   #   touch mydir1/myfile
#   #   cd mydir2
#   #   assert equal "$dir"/mydir1/myfile "$(absolute_path ../mydir1/myfile)"
#   #   $rm "$dir"
#   # end
#   #
#   # it "determines the path of a directory from a child"
#   #   dir=$($mktempd) || return 1
#   #   cd "$dir"
#   #   $mkdir mydir
#   #   cd mydir
#   #   assert equal "$dir" "$(absolute_path ..)"
#   #   $rm "$dir"
#   # end
#   #
#   # it "determines the path of a file from a child"
#   #   dir=$($mktempd) || return 1
#   #   cd "$dir"
#   #   $mkdir mydir
#   #   touch myfile
#   #   cd mydir
#   #   assert equal "$dir"/myfile "$(absolute_path ../myfile)"
#   #   $rm "$dir"
#   # end
#   #
#   # it "fails on a nonexistent file path"
#   #   dir=$($mktempd) || return 1
#   #   stop_on_error off
#   #   absolute_path "$dir"/myfile >/dev/null
#   #   assert unequal 0 $?
#   #   stop_on_error
#   #   $rm "$dir"
#   # end
#   #
#   # it "fails on a nonexistent directory path"
#   #   dir=$($mktempd) || return 1
#   #   shpec_cleanup "$dir"
#   #   stop_on_error off
#   #   absolute_path "$dir" >/dev/null
#   #   assert unequal 0 $?
#   #   stop_on_error
#   # end
# end

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
# describe 'basename'
#   it "returns everything past the last slash"
#     assert equal name "$(basename /my/name)"
#   end
# end
#
# describe 'defa'
#   it "strips each line of a heredoc and assigns each to an element of an array"
#     defa results <<'EOS'
#       one
#       two
#       three
# EOS
#     expected='declare -a results=%s([0]="one" [1]="two" [2]="three")%s'
#     printf -v expected "$expected" \' \'
#     assert equal "$expected" "$(declare -p results)"
#   end
#
#   it "doesn't preserve existing contents"
#     results=( four )
#     defa results <<'EOS'
#       one
#       two
#       three
# EOS
#     expected='declare -a results=%s([0]="one" [1]="two" [2]="three")%s'
#     printf -v expected "$expected" \' \'
#     assert equal "$expected" "$(declare -p results)"
#   end
# end
#
# describe 'defs'
#   it "strips each line of a heredoc and assigns to a string"
#     defs result <<'EOS'
#       one
#       two
#       three
# EOS
#     expected='declare -- result="one\ntwo\nthree"'
#     printf -v expected "$expected"
#     assert equal "$expected" "$(declare -p result)"
#   end
#
#   it "doesn't preserve existing contents"
#     result='four'
#     defs result <<'EOS'
#       one
#       two
#       three
# EOS
#     expected='declare -- result="one\ntwo\nthree"'
#     printf -v expected "$expected"
#     assert equal "$expected" "$(declare -p result)"
#   end
#
#   it "leaves a blank line intact"
#     defs result <<'EOS'
#       one
#       two
#
#       four
# EOS
#     expected='declare -- result="one\ntwo\n\nfour"'
#     printf -v expected "$expected"
#     assert equal "$expected" "$(declare -p result)"
#   end
# end
#
# describe 'dirname'
#   it "finds the directory name"
#     assert equal one/two "$(dirname one/two/three)"
#   end
#
#   it "finds the directory name with trailing slash"
#     assert equal one/two "$(dirname one/two/three/)"
#   end
#
#   it "finds the directory name without slash"
#     assert equal . "$(dirname one)"
#   end
# end
#
# describe 'geta'
#   it "assigns each line of an input to an element of an array"
#     unset -v results
#     geta results <<'EOS'
#       zero
#       one
#       two
# EOS
#     expected='declare -a results=%s([0]="      zero" [1]="      one" [2]="      two")%s'
#     printf -v expected "$expected" \' \'
#     assert equal "$expected" "$(declare -p results)"
#   end
#
#   it "preserves a blank line"
#     unset -v results
#     geta results <<'EOS'
#       zero
#       one
#
#       three
# EOS
#     expected='declare -a results=%s([0]="      zero" [1]="      one" [2]="" [3]="      three")%s'
#     printf -v expected "$expected" \' \'
#     assert equal "$expected" "$(declare -p results)"
#   end
# end
#
# describe 'has_length'
#   it "reports whether an array has a certain length"
#     samples=( 0 )
#     has_length 1 samples
#     assert equal 0 $?
#   end
#
#   it "works for length zero"
#     samples=()
#     has_length 0 samples
#     assert equal 0 $?
#   end
# end

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

# describe 'is_given'
#   it "detects an empty value"
#     sample=''
#     stop_on_error off
#     is_given sample
#     assert unequal 0 $?
#     stop_on_error
#   end
#
#   it "detects a non-empty value"
#     sample=value
#     is_given sample
#     assert equal 0 $?
#   end
#
#   it "detects an unset reference"
#     unset -v sample
#     stop_on_error off
#     is_given sample
#     assert unequal 0 $?
#     stop_on_error
#   end
#
#   it "detects an empty array"
#     samples=()
#     stop_on_error off
#     is_given samples
#     assert unequal 0 $?
#     stop_on_error
#   end
#
#   it "detects a non-empty array"
#     samples=( value )
#     is_given samples
#     assert equal 0 $?
#   end
#
#   it "detects an empty hash"
#     declare -A sampleh=()
#     stop_on_error off
#     is_given sampleh
#     assert unequal 0 $?
#     stop_on_error
#   end
#
#   it "detects a non-empty hash"
#     declare -A sampleh=( [one]=1 )
#     is_given sampleh
#     assert equal 0 $?
#   end
# end
#
# describe 'is_same_as'
#   it "detects equivalent strings"
#     is_same_as one one
#     assert equal 0 $?
#   end
#
#   it "detects non-equivalent strings"
#     stop_on_error off
#     is_same_as one two
#     assert unequal 0 $?
#     stop_on_error
#   end
# end
#
# describe 'is_set'
#   it "returns true if a variable is set"
#     sample=true
#     is_set sample
#     assert equal 0 $?
#   end
#
#   it "returns true if a variable is set to empty"
#     sample=''
#     is_set sample
#     assert equal 0 $?
#   end
#
#   it "returns false if a variable is not set"
#     unset -v sample
#     stop_on_error off
#     is_set sample
#     assert unequal 0 $?
#     stop_on_error
#   end
# end
#
# describe 'is_symlink'
#   it "doesn't identify a file"
#     dir=$($mktempd)
#     validate_dirname "$dir" || return
#     touch "$dir"/file
#     stop_on_error off
#     is_symlink "$dir"/file
#     assert unequal 0 $?
#     stop_on_error
#     shpec_cleanup "$dir"
#   end
#
#   it 'identifies a symlink to a file'
#     dir=$($mktempd)
#     validate_dirname "$dir" || return
#     touch "$dir"/file
#     $ln file "$dir"/filelink
#     is_symlink "$dir"/filelink
#     assert equal 0 $?
#     shpec_cleanup "$dir"
#   end
#
#   it "identifies a symlink to a directory"
#     dir=$($mktempd)
#     validate_dirname "$dir" || return
#     $ln . "$dir"/dirlink
#     is_symlink "$dir"/dirlink
#     assert equal 0 $?
#     shpec_cleanup "$dir"
#   end
#
#   it "doesn't identify a directory"
#     dir=$($mktempd)
#     validate_dirname "$dir" || return
#     stop_on_error off
#     is_symlink "$dir"
#     assert unequal 0 $?
#     stop_on_error
#     shpec_cleanup "$dir"
#   end
# end
#
# describe 'joina'
#   it "joins an array with a delimiter"
#     declare -a samples=([0]=zero [1]=one)
#     assert equal 'zero@one' "$(joina '@' samples)"
#   end
#
#   it "joins an array with one item"
#     declare -a samples=([0]=zero)
#     assert equal 'zero' "$(joina ';' samples)"
#   end
# end
#
# describe 'puts'
#   it "outputs a string on stdout"
#     assert equal sample "$(puts 'sample')"
#   end
# end
#
# describe 'putserr'
#   it "outputs a string on stderr"
#     assert equal sample "$(putserr 'sample' 2>&1)"
#   end
# end
#
# describe 'splits'
#   it "splits a string into an array on a partition character"
#     results=()
#     sample='a=b'
#     splits '=' sample results
#     printf -v expected 'declare -a results=%s([0]="a" [1]="b")%s' \' \'
#     assert equal "$expected" "$(declare -p results)"
#   end
# end
#
# describe 'starts_with'
#   it "detects if a string starts with a specified character"
#     starts_with / /test
#     assert equal 0 $?
#   end
#
#   it "detects if a string doesn't end with a specified character"
#     stop_on_error off
#     starts_with / test
#     assert unequal 0 $?
#     stop_on_error
#   end
# end
#
# describe 'stripa'
#   it "strips each element of an array"
#     results=("    zero" "    one" "    two")
#     stripa results
#     expected=$(printf 'declare -a results=%s([0]="zero" [1]="one" [2]="two")%s' \' \')
#     assert equal "$expected" "$(declare -p results)"
#   end
#
#   it "leaves a blank element intact"
#     results=("    zero" "    one"  "" "    three")
#     stripa results
#     expected='declare -a results=%s([0]="zero" [1]="one" [2]="" [3]="three")%s'
#     printf -v expected "$expected" \' \'
#     assert equal "$expected" "$(declare -p results)"
#   end
# end
#
# describe 'to_lower'
#   it "should lower-case a string"
#     assert equal upper "$(to_lower UPPER)"
#   end
# end
#
# describe 'to_upper'
#   it "should upper-case a string"
#     assert equal LOWER "$(to_upper lower)"
#   end
# end
