source import.bash

eval "$(imports kzn is_directory)"

source shpec-helper.bash
initialize_shpec_helper

describe cleanup
  it "prints a deprecation warning"; (
    stub_command shpec_cleanup

    expected="DEPRECATION: cleanup has been changed to shpec_cleanup. Please change your code."
    assert equal "$expected" "$(cleanup 2>&1)"
    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "calls shpec_cleanup"; (
    stub_command putserr
    stub_command shpec_cleanup 'echo called'

    assert equal called "$(cleanup)"
    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end

describe shpec_cleanup
  it "should delete a given directory"
    dir=$($mktempd) || return 1
    is_directory "$dir"
    assert equal 0 $?
    shpec_cleanup "$dir"
    is_directory "$dir"
    assert unequal 0 $?
  end

  it "should validate before deletion"; (
    stub_command validate_dirname 'printf validate'
    stub_command rm "$(printf 'puts %s rm%s' \' \')"
    result=$(shpec_cleanup)
    assert equal 'validate rm' "$result"
    return "$_shpec_failures" )
  end
end

describe shpec_source
  it "should source a file in the shpec directory"; (
    path=$(absolute_path "$(dirname "$BASH_SOURCE")")
    cd "$path"
    touch shpec_empty.bash
    shpec_source shpec/shpec_empty.bash
    assert equal 0 $?
    $rm shpec_empty.bash
    return "$_shpec_failures" )
  end

  it "should source a file in the shpec directory from a subdirectory"; (
    path=$(absolute_path "$(dirname "$BASH_SOURCE")")
    dir=$(mktemp -qdp "$path") || return 1
    cd "$dir"
    touch ../shpec_empty.bash
    shpec_source shpec/shpec_empty.bash
    assert equal 0 $?
    $rm ../shpec_empty.bash
    $rm "$dir"
    return "$_shpec_failures" )
  end
end

describe validate_dirname
  it "should error on a non-existent directory name"
    dir=$($mktempd) || return 1
    validate_dirname "$dir"/mydir
    assert unequal 0 $?
    $rm "$dir"
  end

  it "should error on empty name"
    validate_dirname ''
    assert unequal 0 $?
  end

  it "should error on /"
    validate_dirname /
    assert unequal 0 $?
  end

  it "should error on a top-level directory name"
    validate_dirname /opt
    assert unequal 0 $?
  end
end
