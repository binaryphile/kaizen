set -o nounset

source "$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")"/../lib/string.bash

describe str_split
  it "splits on the specified delimiter"
    str=a/b/c
    result=$(str_split / "$str")
    assert equal 'a b c' "$result"
  end
end
