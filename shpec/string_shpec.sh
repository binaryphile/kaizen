#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _shpec_dir="${BASH_SOURCE%/*}" || _shpec_dir="$PWD"

source "$_shpec_dir"/../lib/string.sh

describe "str.split"
  it "splits on the specified delimiter"
    # shellcheck disable=SC2034
    sample_s="a/b/c"
    result_a=( $(str.split sample "/") )
    assert equal "$(str.split sample_s "/")" "${result_a[*]}"
  end
end

describe "str.eql?"
  it "exists"
    # shellcheck disable=SC2034
    sample_s="abc"
    str.eql? sample_s "abc"
    assert equal $? 0
  end
end

describe "str.blank?"
  it "exists"
    # shellcheck disable=SC2034
    blank_s=""
    str.blank? blank_s
    assert equal $? 0
  end
end

# describe "String.new"
#   it "adds a blank? method"
#     # shellcheck disable=SC2034
#     sample_s=""
#     String.new sample_s
#     sample_s.blank?
#     assert equal $? 0
#   end
# end
