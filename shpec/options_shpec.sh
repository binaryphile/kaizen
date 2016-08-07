#!/usr/bin/env bash

library=../lib/options.sh
source "${BASH_SOURCE%/*}/$library" 2>/dev/null || source "$library"

describe "options.define"
  it "allows the creation of a boolean option defaulting to false"
    (
    options.define "flag" :boolean false "a flag" "f"
    # shellcheck disable=SC2154
    assert equal "${options[:flag]}" 0
    # shellcheck disable=SC2154
    assert equal "${option_descriptions[:flag]}" "a flag"
    )
  end

  it "allows the creation of a boolean option defaulting to true"
    (
    options.define "flag" :boolean true "a flag" "f"
    # shellcheck disable=SC2154
    assert equal "${options[:flag]}" 1
    assert equal "${option_descriptions[:flag]}" "a flag"
    )
  end

  it "allows the creation of a string option defaulting to empty"
    (
    options.define "stropt" :string "" "a string" "s"
    # shellcheck disable=SC2154
    assert equal "${options[:stropt]}" ""
    assert equal "${option_descriptions[:stropt]}" "a string"
    )
  end

  it "allows the creation of a string option defaulting to \"sample\""
    (
    options.define "stropt" :string "sample" "a string" "s"
    # shellcheck disable=SC2154
    assert equal "${options[:stropt]}" "sample"
    assert equal "${option_descriptions[:stropt]}" "a string"
    )
  end
end

describe "options.parse"
  it "toggles a short-option boolean defaulting to false"
    (
    options.define flag boolean false "a flag" f
    # shellcheck disable=SC2034
    options.parse -f
    # shellcheck disable=SC2154
    assert equal "${options[:flag]}" 1
    )
  end
end
