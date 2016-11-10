declare library=../lib/shpec_helper.bash
source "${BASH_SOURCE%/*}/$library" 2>/dev/null || source "$library"
unset -v library

initialize_shpec_helper

shpec_source lib/kaizen.bash
initialize_kaizen


describe "absolute_path"
  it "determines the path of a directory from the parent"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    # shellcheck disable=SC2154
    $mkdir mydir
    assert equal "$(absolute_path mydir)" "$dir"/mydir
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "determines the path of a file from the parent"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    $mkdir mydir
    # shellcheck disable=SC2154
    touch mydir/myfile
    assert equal "$(absolute_path mydir/myfile)" "$dir"/mydir/myfile
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "determines the path of a directory from itself"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    # shellcheck disable=SC2154
    assert equal "$(absolute_path .)" "$dir"
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "determines the path of a file from the itself"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    # shellcheck disable=SC2154
    touch myfile
    assert equal "$(absolute_path myfile)" "$dir"/myfile
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "determines the path of a directory from a sibling"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    $mkdir mydir1
    $mkdir mydir2
    cd mydir2
    # shellcheck disable=SC2154
    assert equal "$(absolute_path ../mydir1)" "$dir"/mydir1
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "determines the path of a file from a sibling"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    $mkdir mydir1
    $mkdir mydir2
    # shellcheck disable=SC2154
    touch mydir1/myfile
    cd mydir2
    assert equal "$(absolute_path ../mydir1/myfile)" "$dir"/mydir1/myfile
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "determines the path of a directory from a child"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    $mkdir mydir
    cd mydir
    # shellcheck disable=SC2154
    assert equal "$(absolute_path ..)" "$dir"
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "determines the path of a file from a child"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    $mkdir mydir
    touch myfile
    cd mydir
    # shellcheck disable=SC2154
    assert equal "$(absolute_path ../myfile)" "$dir"/myfile
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "fails on a nonexistent path"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    result=$(absolute_path "$dir"/myfile)
    assert equal 1 $?
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "contains"
  it "identifies a character in a string"; ( _shpec_failures=0   # shellcheck disable=SC2030

    contains / one/two
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify a missing character in a string"; ( _shpec_failures=0   # shellcheck disable=SC2030

    contains / one_two
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify a character in an empty string"; ( _shpec_failures=0   # shellcheck disable=SC2030

    contains / ""
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "def_ary"
  it "assigns each line of a heredoc to an element of an array"; ( _shpec_failures=0   # shellcheck disable=SC2030

    def_ary sample <<'EOS'
one
two
three
EOS
    # shellcheck disable=SC2154
    assert equal ${#sample} 3
    assert equal "${sample[*]}" "one two three"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "define"
  it "assigns a heredoc to a variable"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define sample <<<"testing one two three"
    assert equal "$sample" "testing one two three"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "dirname"
  it "finds the directory name"; ( _shpec_failures=0   # shellcheck disable=SC2030

    assert equal "$(dirname one/two/three)" "one/two"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "finds the directory name with trailing slash"; ( _shpec_failures=0   # shellcheck disable=SC2030

    assert equal "$(dirname one/two/three/)" "one/two"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "finds the directory name without slash"; ( _shpec_failures=0   # shellcheck disable=SC2030

    assert equal "$(dirname one)" "."

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "ends_with"
  it "detects if a string ends with a specified character"; ( _shpec_failures=0   # shellcheck disable=SC2030

    ends_with / test/
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "detects if a string doesn't end with a specified character"; ( _shpec_failures=0   # shellcheck disable=SC2030

    ends_with / test
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "extension"
  it "finds the extension"; ( _shpec_failures=0   # shellcheck disable=SC2030

    assert equal "$(extension nixpkgs.package)" "package"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "files_match"
  it "is false if none of the files exist"; ( _shpec_failures=0   # shellcheck disable=SC2030

    files_match "/path/to/no/file/1" "/path/to/no/file/2"
    assert equal $? 2

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "is false if the files exist but do not match"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return

    echo 'a' > "$temp/a.txt"
    echo 'b' > "$temp/b.txt"

    files_match "$temp/a.txt" "$temp/b.txt"
    assert equal $? 1

    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "is true if the files exist and match"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return

    echo 'a' > "$temp/a.txt"
    echo 'a' > "$temp/b.txt"

    files_match "$temp/a.txt" "$temp/b.txt"
    assert equal $? 0

    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "has_any"
  it "should identify a positive number of arguments"; ( _shpec_failures=0   # shellcheck disable=SC2030

    has_any 1
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "shouldn't identify zero arguments"; ( _shpec_failures=0   # shellcheck disable=SC2030

    has_any
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "has_fewer_than"
  it "should identify numbers of arguments less than specified"; ( _shpec_failures=0   # shellcheck disable=SC2030

    has_fewer_than 2 one
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "shouldn't identify numbers of arguments not less than specified"; ( _shpec_failures=0   # shellcheck disable=SC2030

    has_fewer_than 2 one two
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "has_more_than"
  it "should identify numbers of arguments greater than specified"; ( _shpec_failures=0   # shellcheck disable=SC2030

    has_more_than 2 one two three
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "shouldn't identify numbers of arguments not greater than specified"; ( _shpec_failures=0   # shellcheck disable=SC2030

    has_more_than 2 one two
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "has_none"
  it "should identify zero arguments"; ( _shpec_failures=0   # shellcheck disable=SC2030

    has_none
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "shouldn't identify a positive number of arguments"; ( _shpec_failures=0   # shellcheck disable=SC2030

    has_none 1
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "initialize_kaizen"
  it "calls sandbox_environment"; ( _shpec_failures=0   # shellcheck disable=SC2030

    stub_command sandbox_environment "echo sandbox_environment"
    assert equal "$(initialize_kaizen)" "sandbox_environment"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


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


describe "is_directory"
  it "identifies a directory"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    is_directory "$temp"
    assert equal $? 0
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "identifies a symlink to a directory"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    resolve_ln -sfT . "$temp"/dirlink
    is_directory "$temp"/dirlink
    assert equal $? 0
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify a symlink to a file"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    resolve_ln -sfT file "$temp"/filelink
    is_directory "$temp"/filelink
    assert equal $? 1
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify a file"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    is_directory "$temp"/file
    assert equal $? 1
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "is_executable"
  it "identifies an executable file"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    chmod 755 "$temp"/file
    is_executable "$temp"/file
    assert equal $? 0
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "identifies an executable directory"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    mkdir "$temp"/dir
    chmod 755 "$temp"/dir
    is_executable "$temp"/dir
    assert equal $? 0
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify an non-executable file"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    is_executable "$temp"/file
    assert equal $? 1
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify a non-executable directory"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    mkdir "$temp"/dir
    chmod 664 "$temp"/dir
    is_executable "$temp"/dir
    assert equal $? 1
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "identifies a link to an executable file"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    chmod 755 "$temp"/file
    resolve_ln -sf file "$temp"/link
    is_executable "$temp"/link
    assert equal $? 0
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "identifies a link to an executable directory"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    mkdir "$temp"/dir
    chmod 755 "$temp"/dir
    resolve_ln -sfT dir "$temp"/link
    is_executable "$temp"/link
    assert equal $? 0
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify a link to a non-executable file"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    resolve_ln -sf file "$temp"/link
    is_executable "$temp"/link
    assert equal $? 1
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify a link to a non-executable directory"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    mkdir "$temp"/dir
    chmod 664 "$temp"/dir
    resolve_ln -sfT dir "$temp"/link
    is_executable "$temp"/link
    assert equal $? 1
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "is_file"
  it "identifies a file"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    is_file "$temp"/file
    assert equal $? 0
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "identifies a symlink to a file"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/file
    resolve_ln -sfT file "$temp"/filelink
    is_file "$temp"/filelink
    assert equal $? 0
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify a symlink to a directory"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    resolve_ln -sfT . "$temp"/dirlink
    is_file "$temp"/dirlink
    assert equal $? 1
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify a directory"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    is_file "$temp"
    assert equal $? 1
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "is_function"
  it "identifies a function"; ( _shpec_failures=0   # shellcheck disable=SC2030

    sample() { :;}
    is_function sample
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "errors on a non-function"; ( _shpec_failures=0   # shellcheck disable=SC2030

    is_function sample
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "is_given"
  it "detects an unset variable"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2031
    is_given "$dummy"
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "detects an empty variable"; ( _shpec_failures=0   # shellcheck disable=SC2030

    dummy=""
    is_given "$dummy"
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "detects an set variable"; ( _shpec_failures=0   # shellcheck disable=SC2030

    variable=value
    # shellcheck disable=SC2154
    is_given "$variable"
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "is_group"
  it "should identify a group which exists"; ( _shpec_failures=0   # shellcheck disable=SC2030

    is_group "$(current_user_group)"
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "shouldn't identify a group which doesn't exist"; ( _shpec_failures=0   # shellcheck disable=SC2030

    is_group blaoi
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "is_hash"
  it "identifies an associative array"; ( _shpec_failures=0   # shellcheck disable=SC2030

    declare -A sample=( [one]=1 [two]=2 )
    is_hash sample
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "gives a reference a pass"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2034
    declare -A sample1=( [one]=1 [two]=2 )
    # shellcheck disable=SC2034
    declare -n sample2=sample1
    is_hash sample2
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify not an associative array"; ( _shpec_failures=0   # shellcheck disable=SC2030

    sample=( one two )
    is_hash sample
    assert unequal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't identify an undefined variable name"; ( _shpec_failures=0   # shellcheck disable=SC2030

    unset -v sample
    is_hash sample
    assert unequal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "is_mounted"
  it "should call the correct mount tool for the operating system"; ( _shpec_failures=0   # shellcheck disable=SC2030

    if [[ $OSTYPE == darwin* ]]; then
      stub_command diskutil '[[ $* == "info /nix" ]]'
      is_mounted /nix
      assert equal $? 0
      unstub_command diskutil
    else
      stub_command mount "echo '/nix'"
      is_mounted /nix
      assert equal $? 0
      unstub_command mount
    fi

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "should fail a wrong call for the operating system"; ( _shpec_failures=0   # shellcheck disable=SC2030

    if [[ $OSTYPE == darwin* ]]; then
      stub_command diskutil '[[ $* == "info /nix" ]]'
      is_mounted /mydir
      assert equal $? 1
      unstub_command diskutil
    else
      stub_command mount "echo '/nix'"
      is_mounted /mydir
      assert equal $? 1
      unstub_command mount
    fi

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "is_user"
  it "should identify a user account which exists"; ( _shpec_failures=0   # shellcheck disable=SC2030

    is_user "$USER"
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "shouldn't identify a user account which doesn't exist"; ( _shpec_failures=0   # shellcheck disable=SC2030

    is_user blah
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "mode"
  it "returns an octal string mode for a file"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cd "$dir"
    touch myfile
    result=$(mode myfile)
    assert equal 0 $?
    assert equal "664" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "returns an octal string mode for a directory"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    result=$(mode "$dir")
    assert equal 0 $?
    assert equal "700" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "is_owned_by"
  it "should detect a directory owned by a user"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    is_owned_by "$USER" "$temp"
    assert equal $? 0
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "shouldn't detect a directory not owned by a user"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    is_owned_by flad "$temp"
    assert equal $? 1
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "should detect a file owned by a user"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/myfile
    is_owned_by "$USER" "$temp"/myfile
    assert equal $? 0
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "shouldn't detect a file not owned by a user"; ( _shpec_failures=0   # shellcheck disable=SC2030

    temp=$(make_temp_dir)
    validate_dirname "$temp" || return
    touch "$temp"/myfile
    is_owned_by flad "$temp"/myfile
    assert equal $? 1
    cleanup "$temp"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "quietly"
  it "suppresses stdout with a dot instead"; ( _shpec_failures=0   # shellcheck disable=SC2030

    assert equal "$(quietly echo hello)" "."

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "suppresses stderr with a dot instead"; ( _shpec_failures=0   # shellcheck disable=SC2030

    assert equal "$(quietly "echo hello 1>&2")" "."

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't output anything if silent set"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2034
    silent=true
    assert equal "$(quietly echo hello)" ""

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "doesn't suppress stdout if debug set"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2034
    debug=true
    assert equal "$(quietly echo hello)" "hello"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  # it "doesn't suppress stderr if debug set"; ( _shpec_failures=0   # shellcheck disable=SC2030

  #   # shellcheck disable=SC2034
  #   debug=true
  #   assert equal "$(quietly "echo hello >&2" 2>&1)" "hello"

    # return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  # end
end


# describe "remotely"
#   it "allows remote execution of a command"; ( _shpec_failures=0   # shellcheck disable=SC2030

#     target=localhost
#     assert equal "$(remotely echo hello)" "/home/ted"

    # return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
#   end
# Also test agent forwarding?
# end


describe "is_same_as"
  it "detects equivalent strings"; ( _shpec_failures=0   # shellcheck disable=SC2030

    is_same_as "one" "one"
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "detects non-equivalent strings"; ( _shpec_failures=0   # shellcheck disable=SC2030

    is_same_as "one" "two"
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "sandbox_environment"
  it "sets the umask to 0002"; ( _shpec_failures=0   # shellcheck disable=SC2030

    sandbox_environment
    assert equal "$(umask)" "0002"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "split_str"
  it "splits a string on a specified character"; ( _shpec_failures=0   # shellcheck disable=SC2030

    sample=user@host
    local -a result
    split_str @ "$sample" result
    # shellcheck disable=SC2034
    assert equal "user host" "${result[*]}"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "starts_with"
  it "detects if a string starts with a specified character"; ( _shpec_failures=0   # shellcheck disable=SC2030

    starts_with / /test
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "detects if a string doesn't end with a specified character"; ( _shpec_failures=0   # shellcheck disable=SC2030

    starts_with / test
    assert equal $? 1

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end


describe "succeed"
  it "should mask false"; ( _shpec_failures=0   # shellcheck disable=SC2030

    succeed false
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "shouldn't alter true"; ( _shpec_failures=0   # shellcheck disable=SC2030

    succeed true
    assert equal $? 0

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
