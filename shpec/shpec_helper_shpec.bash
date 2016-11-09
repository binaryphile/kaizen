source "${BASH_SOURCE%/*}"/../lib/shpec_helper.bash 2>/dev/null || source ../lib/shpec_helper.bash
initialize_shpec_helper


describe "cleanup"
  it "should delete a given directory"; ( _shpec_failures=0                     # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    tempdir=$($mktempd) || return 1
    is_directory "$tempdir"
    assert equal 0 $?
    cleanup "$tempdir"
    is_directory "$tempdir"
    assert equal 1 $?

    return "$_shpec_failures"); (( _shpec_failures += $? )) ||:
  end

  it "should validate before deletion"; ( _shpec_failures=0                     # shellcheck disable=SC2030

    stub_command validate_dirname "printf validate"
    stub_command rm "echo ' rm'"
    result=$(cleanup)
    assert equal "validate rm" "$result"

    return "$_shpec_failures"); (( _shpec_failures += $? )) ||:
  end
end


describe "shpec_source"
  it "should source a file in the shpec directory"; ( _shpec_failures=0       # shellcheck disable=SC2030

    path=$(absolute_path "$(dirname "$BASH_SOURCE")")
    cd "$path"
    shpec_source shpec/shpec_empty.bash
    assert equal 0 $?

    return "$_shpec_failures"); (( _shpec_failures += $? )) ||:
  end

  it "should source a file in the shpec directory from a subdirectory"; ( _shpec_failures=0       # shellcheck disable=SC2030

    path=$(absolute_path "$(dirname "$BASH_SOURCE")")
    dir=$(mktemp -qdp "$path") || return 1
    cd "$dir"
    # shellcheck disable=SC2154
    shpec_source shpec/shpec_empty.bash
    assert equal 0 $?
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures"); (( _shpec_failures += $? )) ||:
  end
end


describe "validate_dirname"
  it "should error on a non-existent directory name"; ( _shpec_failures=0       # shellcheck disable=SC2030

    tempdir=$($mktempd) || return 1
    validate_dirname "$tempdir"/mydir
    assert equal 1 $?
    $rm "$tempdir"

    return "$_shpec_failures"); (( _shpec_failures += $? )) ||:
  end

  it "should error on empty name"; ( _shpec_failures=0                        # shellcheck disable=SC2030

    validate_dirname ""
    assert equal 1 $?

    return "$_shpec_failures"); (( _shpec_failures += $? )) ||:
  end

  it "should error on /"; ( _shpec_failures=0                                 # shellcheck disable=SC2030

    validate_dirname /
    assert equal 1 $?

    return "$_shpec_failures"); (( _shpec_failures += $? )) ||:
  end

  it "should error on a top-level directory name"; ( _shpec_failures=0                                 # shellcheck disable=SC2030

    validate_dirname /opt
    assert equal 1 $?

    return "$_shpec_failures"); (( _shpec_failures += $? )) ||:
  end
end
