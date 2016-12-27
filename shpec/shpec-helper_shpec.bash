source kzn.bash

source shpec-helper.bash
initialize_shpec_helper

describe 'cleanup'
  it 'should delete a given directory'
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    is_directory "$dir"
    assert equal 0 $?
    cleanup "$dir"
    is_directory "$dir"
    assert unequal 0 $?
  end

  it 'should validate before deletion'; (
    stub_command validate_dirname 'printf validate'
    stub_command rm "$(printf 'puts %s rm%s' \' \')"
    result=$(cleanup)
    assert equal 'validate rm' "$result"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end
end


describe 'shpec_source'
  it 'should source a file in the shpec directory'; (
    path=$(absolute_path "$(dirname "$BASH_SOURCE")")
    cd "$path"
    touch shpec_empty.bash
    shpec_source shpec/shpec_empty.bash
    assert equal 0 $?
    # shellcheck disable=SC2154
    $rm shpec_empty.bash
    return "$_shpec_failures" )
  end

  it 'should source a file in the shpec directory from a subdirectory'; (
    path=$(absolute_path "$(dirname "$BASH_SOURCE")")
    dir=$(mktemp -qdp "$path") || return 1
    cd "$dir"
    touch ../shpec_empty.bash
    # shellcheck disable=SC2154
    shpec_source shpec/shpec_empty.bash
    assert equal 0 $?
    # shellcheck disable=SC2154
    $rm ../shpec_empty.bash
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end
end

describe 'validate_dirname'
  it 'should error on a non-existent directory name'
    dir=$($mktempd) || return 1
    validate_dirname "$dir"/mydir
    assert unequal 0 $?
    $rm "$dir"
  end

  it 'should error on empty name'
    validate_dirname ""
    assert unequal 0 $?
  end

  it 'should error on /';
    validate_dirname /
    assert unequal 0 $?
  end

  it 'should error on a top-level directory name'
    validate_dirname /opt
    assert unequal 0 $?
  end
end
