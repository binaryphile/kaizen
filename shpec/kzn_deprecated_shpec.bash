describe 'contains'
  it 'identifies a character in a string'
    contains / one/two
    assert equal $? 0
  end

  it "doesn't identify a missing character in a string"
    contains / one_two
    assert equal $? 1
  end

  it "doesn't identify a character in an empty string"
    contains / ''
    assert equal $? 1
  end
end

describe 'copya'
  it 'copies an array'
    # shellcheck disable=SC2030
    sample=( one two three )
    declare -a resulta
    copya sample resulta
    expected='declare -a resulta=%s([0]="one" [1]="two" [2]="three")%s'
    # shellcheck disable=SC2059
    printf -v expected "$expected" \' \'
    assert equal "$expected" "$(declare -p resulta)"
  end
end

describe 'def_ary'
  it 'assigns each line of a heredoc to an element of an array'
    def_ary sample <<'EOS' 2>/dev/null
zero
one
two
EOS
    printf -v expected 'declare -a sample=%s([0]="zero" [1]="one" [2]="two")%s' \' \'
    # shellcheck disable=SC2030
    assert equal "$expected" "$(declare -p sample)"
  end

  it 'is deprecated'
    result=$(def_ary sample <<'EOS' 2>&1
zero
one
two
EOS
    )
    assert equal 'def_ary is deprecated, please use geta instead.' "$result"
  end
end

describe 'define'
  it 'assigns a heredoc to a variable'
    define sample <<<'testing one two three'
    # shellcheck disable=SC2031
    assert equal "$sample" 'testing one two three'
  end

  it 'is deprecated'
    result=$(define sample <<<'testing one two three' 2>&1)
    assert equal 'define is deprecated, please use defs or gets instead.' "$result"
  end
end

describe 'ends_with'
  it 'detects if a string ends with a specified character'
    ends_with / test/
    assert equal $? 0
  end

  it "detects if a string doesn't end with a specified character"
    ends_with / test
    assert equal $? 1
  end
end

describe 'extension'
  it 'finds the extension'
    assert equal "$(extension nixpkgs.package)" 'package'
  end
end

describe 'files_match'
  it 'is false if none of the files exist'
    files_match '/path/to/no/file/1' '/path/to/no/file/2'
    assert equal $? 2
  end

  it 'is false if the files exist but do not match'
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return

    echo 'a' > "$temp/a.txt"
    echo 'b' > "$temp/b.txt"

    files_match "$temp/a.txt" "$temp/b.txt"
    assert equal $? 1

    cleanup "$temp"
  end

  it 'is true if the files exist and match'
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return

    echo 'a' > "$temp/a.txt"
    echo 'a' > "$temp/b.txt"

    files_match "$temp/a.txt" "$temp/b.txt"
    assert equal $? 0

    cleanup "$temp"
  end
end

describe 'has_any'
  it 'should identify a positive number of arguments'
    has_any 1
    assert equal $? 0
  end

  it "shouldn't identify zero arguments"
    has_any
    assert equal $? 1
  end
end

describe 'has_fewer_than'
  it 'should identify numbers of arguments less than specified'
    has_fewer_than 2 one
    assert equal $? 0
  end

  it "shouldn't identify numbers of arguments not less than specified"
    has_fewer_than 2 one two
    assert equal $? 1
  end
end

describe 'has_more_than'
  it 'should identify numbers of arguments greater than specified'
    has_more_than 2 one two three
    assert equal $? 0
  end

  it "shouldn't identify numbers of arguments not greater than specified"
    has_more_than 2 one two
    assert equal $? 1
  end
end

describe 'has_none'
  it 'should identify zero arguments'
    has_none
    assert equal $? 0
  end

  it "shouldn't identify a positive number of arguments"
    has_none 1
    assert equal $? 1
  end
end

describe 'initialize_kzn'
  it 'calls sandbox_environment'; (
    stub_command sandbox_environment 'echo sandbox_environment'
    assert equal "$(initialize_kzn)" 'sandbox_environment'
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end
end

describe 'is_executable'
  it 'identifies an executable file'
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    chmod 755 "$temp"/file
    is_executable "$temp"/file
    assert equal $? 0
    cleanup "$temp"
  end

  it 'identifies an executable directory'
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    mkdir "$temp"/dir
    chmod 755 "$temp"/dir
    is_executable "$temp"/dir
    assert equal $? 0
    cleanup "$temp"
  end

  it "doesn't identify an non-executable file"
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    is_executable "$temp"/file
    assert equal $? 1
    cleanup "$temp"
  end

  it "doesn't identify a non-executable directory"
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    mkdir "$temp"/dir
    chmod 664 "$temp"/dir
    is_executable "$temp"/dir
    assert equal $? 1
    cleanup "$temp"
  end

  it 'identifies a link to an executable file'
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    chmod 755 "$temp"/file
    # shellcheck disable=SC2154
    $ln file "$temp"/link
    is_executable "$temp"/link
    assert equal $? 0
    cleanup "$temp"
  end

  it 'identifies a link to an executable directory'
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    mkdir "$temp"/dir
    chmod 755 "$temp"/dir
    # shellcheck disable=SC2154
    $ln dir "$temp"/link
    is_executable "$temp"/link
    assert equal $? 0
    cleanup "$temp"
  end

  it "doesn't identify a link to a non-executable file"
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    # shellcheck disable=SC2154
    $ln file "$temp"/link
    is_executable "$temp"/link
    assert equal $? 1
    cleanup "$temp"
  end

  it "doesn't identify a link to a non-executable directory"
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    mkdir "$temp"/dir
    chmod 664 "$temp"/dir
    # shellcheck disable=SC2154
    $ln dir "$temp"/link
    is_executable "$temp"/link
    assert equal $? 1
    cleanup "$temp"
  end
end

describe 'is_function'
  it 'identifies a function'; (
    sample() { :;}
    is_function sample
    assert equal $? 0
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end

  it 'errors on a non-function'
    is_function sample
    assert equal $? 1
  end
end

describe 'is_group'
  it 'should identify a group which exists'
    is_group "$(current_user_group)"
    assert equal $? 0
  end

  it "shouldn't identify a group which doesn't exist"
    is_group blaoi
    assert equal $? 1
  end
end

describe 'is_hash'
  it 'identifies an associative array by name'
    declare -A sampleh=( [one]=1 [two]=2 )
    is_hash :sampleh
    assert equal $? 0
  end

  it 'gives a reference a pass'; (
    # shellcheck disable=SC2034
    declare -A sample1=( [one]=1 [two]=2 )
    # shellcheck disable=SC2034
    declare -n sample2=sample1
    is_hash :sample2
    assert equal $? 0
    return "$_shpec_failures" )
  end

  it "doesn't identify not an associative array"
    samplea=( one two )
    is_hash :samplea
    assert unequal $? 0
  end

  it "doesn't identify an undefined variable name"
    unset -v sample
    is_hash :sample
    assert unequal $? 0
  end
end

describe 'is_mounted'
  it 'should call the correct mount tool for the operating system'; (
    if [[ $OSTYPE == darwin* ]]; then
      stub_command diskutil '[[ $* == "info /nix" ]]'
      is_mounted /nix
      assert equal $? 0
    else
      stub_command mount "echo '/nix'"
      is_mounted /nix
      assert equal $? 0
    fi
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end

  it 'should fail a wrong call for the operating system'; (
    if [[ $OSTYPE == darwin* ]]; then
      stub_command diskutil '[[ $* == "info /nix" ]]'
      is_mounted /mydir
      assert equal $? 1
    else
      stub_command mount "echo '/nix'"
      is_mounted /mydir
      assert equal $? 1
    fi
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end
end

describe 'is_symbol'
  it 'identifies a symbol'
    is_symbol :symbol
    assert equal 0 $?
  end

  it "doesn't identify a non-symbol"
    is_symbol non-symbol
    assert equal 1 $?
  end
end

describe 'is_user'
  it 'should identify a user account which exists'
    is_user "$USER"
    assert equal $? 0
  end

  it "shouldn't identify a user account which doesn't exist"
    is_user blah
    assert equal $? 1
  end
end

describe 'mode'
  it 'returns an octal string mode for a file'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    touch myfile
    result=$(mode myfile)
    assert equal 0 $?
    assert equal '664' "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
  end

  it 'returns an octal string mode for a directory'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    result=$(mode "$dir")
    assert equal 0 $?
    assert equal '700' "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
  end
end

describe 'is_owned_by'
  it 'should detect a directory owned by a user'
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    is_owned_by "$USER" "$temp"
    assert equal $? 0
    cleanup "$temp"
  end

  it "shouldn't detect a directory not owned by a user"
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    is_owned_by flad "$temp"
    assert equal $? 1
    cleanup "$temp"
  end

  it 'should detect a file owned by a user'
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/myfile
    is_owned_by "$USER" "$temp"/myfile
    assert equal $? 0
    cleanup "$temp"
  end

  it "shouldn't detect a file not owned by a user"
    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/myfile
    is_owned_by flad "$temp"/myfile
    assert equal $? 1
    cleanup "$temp"
  end
end

describe 'quietly'
  it 'suppresses stdout with a dot instead'
    assert equal "$(quietly echo hello)" '.'
  end

  it 'suppresses stderr with a dot instead'
    assert equal "$(quietly "echo hello 1>&2")" '.'
  end

  it "doesn't output anything if silent set"; (
    # shellcheck disable=SC2034
    silent=true
    assert equal "$(quietly echo hello)" ''
    return "$_shpec_failures" )
  end

  it "doesn't suppress stdout if debug set"; (
    # shellcheck disable=SC2034
    debug=true
    assert equal "$(quietly echo hello)" 'hello'
    return "$_shpec_failures" )
  end

  # it "doesn't suppress stderr if debug set"; (

  #   # shellcheck disable=SC2034
  #   debug=true
  #   assert equal "$(quietly "echo hello >&2" 2>&1)" "hello"

    # return "$_shpec_failures" )
  # end
end

# describe "remotely"
#   it "allows remote execution of a command"; (

#     target=localhost
#     assert equal "$(remotely echo hello)" "/home/ted"

    # return "$_shpec_failures" )
#   end
# Also test agent forwarding?
# end

describe 'sandbox_environment'
  it 'sets the umask to 0002'; (
    sandbox_environment >/dev/null
    assert equal "$(umask)" '0002'
    return "$_shpec_failures" )
  end
end

describe 'split_str'
  it 'splits a string on a specified character'; (
    sample=user@host
    local -a resulta
    split_str @ "$sample" resulta
    # shellcheck disable=SC2034
    assert equal 'user host' "${resulta[*]}"
    return "$_shpec_failures" )
  end
end

describe 'succeed'
  it 'should mask false'
    succeed false
    assert equal $? 0
  end

  it "shouldn't alter true"
    succeed true
    assert equal $? 0
  end
end

describe 'to_lower'
  it 'should lower-case a string'
    assert equal upper "$(to_lower UPPER)"
  end
end
