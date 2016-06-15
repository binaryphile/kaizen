#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="$PWD"

source "$_shpec_dir"/../lib/string.sh

describe "String.split"
  it "splits on the specified delimiter"
    # shellcheck disable=SC2034
    sample_s="a/b/c"
    assert equal "$(String.split sample_s "/")" "a b c"
  end
end

describe "String.eql?"
  it "exists"
    # shellcheck disable=SC2034
    sample_s="abc"
    String.eql? sample_s "abc"
    assert equal $? 0
  end
end

describe "String.blank?"
  it "exists"
    # shellcheck disable=SC2034
    blank_s=""
    String.blank? blank_s
    assert equal $? 0
  end
end

describe "String.new"
  it "adds a blank? method"
    # shellcheck disable=SC2034
    sample_s=""
    String.new sample_s
    sample_s.blank?
    assert equal $? 0
  end

  it "adds a blank? method which detects non-blanks"
    # shellcheck disable=SC2034
    sample_s="a"
    String.new sample_s
    sample_s.blank?
    assert equal $? 1
  end

  it "adds a eql? method"
    # shellcheck disable=SC2034
    sample_s="a"
    String.new sample_s
    sample_s.eql? "a"
    assert equal $? 0
  end

  it "adds a eql? method which detects inequality"
    # shellcheck disable=SC2034
    sample_s="a"
    String.new sample_s
    sample_s.eql? "b"
    assert equal $? 1
  end

  it "adds the rest of the String methods"
    # shellcheck disable=SC2034
    sample_s="a"
    String.new sample_s
    # shellcheck disable=SC2034
    result="$(sample_s.split)"
    sample_s.exit_if_blank?
    assert equal $? 0
  end
end
