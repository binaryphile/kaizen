#!/usr/bin/env bash

library=../lib/options.sh
source "${BASH_SOURCE%/*}/$library" 2>/dev/null || source "$library"

describe "options._add_short_option"
  it "adds a boolean option without a \":\""
    (
    opt=b
    type=:boolean
    short_getopt=""
    options._add_short_option :short_getopt :opt :type
    # shellcheck disable=SC2154
    assert equal "$short_getopt" "b"
    )
  end

  it "adds a string option with a \":\""
    (
    opt=s
    type=:string
    short_getopt=""
    options._add_short_option :short_getopt :opt :type
    assert equal "$short_getopt" "s:"
    )
  end

  it "adds a second option"
    (
    opt=b
    type=:boolean
    short_getopt=""
    options._add_short_option :short_getopt :opt :type
    # shellcheck disable=SC2034
    opt=s
    # shellcheck disable=SC2034
    type=:string
    options._add_short_option :short_getopt :opt :type
    # shellcheck disable=SC2154
    assert equal "$short_getopt" "bs:"
    )
  end
end

describe "options._add_long_option"
  it "adds a boolean option without a \":\""
    (
    # shellcheck disable=SC2034
    opt=flag
    # shellcheck disable=SC2034
    type=:boolean
    long_getopt=""
    options._add_long_option :long_getopt :opt :type
    # shellcheck disable=SC2154
    assert equal "$long_getopt" "flag"
    )
  end

  it "adds a string option with a \":\""
    (
    # shellcheck disable=SC2034
    opt=strval
    # shellcheck disable=SC2034
    type=:string
    long_getopt=""
    options._add_long_option :long_getopt :opt :type
    assert equal "$long_getopt" "strval:"
    )
  end

  it "adds a second option"
    (
    opt=flag
    type=:boolean
    long_getopt=""
    options._add_long_option :long_getopt :opt :type
    # shellcheck disable=SC2034
    opt=strval
    # shellcheck disable=SC2034
    type=:string
    options._add_long_option :long_getopt :opt :type
    # shellcheck disable=SC2154
    assert equal "$long_getopt" "flag,strval:"
    )
  end
end

describe "options.define"
  it "allows the creation of a boolean option defaulting to false"
    (
    options.define "flag" :boolean false "a flag" "f"
    # shellcheck disable=SC2154
    assert equal "${options[:flag]}" 0
    # shellcheck disable=SC2154
    assert equal "${options_descriptions[:flag]}" "a flag"
    # shellcheck disable=SC2154
    assert equal "$options_short_getopt" "f"
    # shellcheck disable=SC2154
    assert equal "$options_long_getopt" "flag"
    )
  end

  it "allows the creation of a boolean option defaulting to true"
    (
    options.define "flag" :boolean true "a flag" "f"
    # shellcheck disable=SC2154
    assert equal "${options[:flag]}" 1
    assert equal "${options_descriptions[:flag]}" "a flag"
    )
  end

  it "allows the creation of a boolean option defaulting to 0 (false)"
    (
    options.define "flag" :boolean 0 "a flag" "f"
    # shellcheck disable=SC2154
    assert equal "${options[:flag]}" 0
    # shellcheck disable=SC2154
    assert equal "${options_descriptions[:flag]}" "a flag"
    )
  end

  it "allows the creation of a boolean option defaulting to 1 (true)"
    (
    options.define "flag" :boolean 1 "a flag" "f"
    # shellcheck disable=SC2154
    assert equal "${options[:flag]}" 1
    assert equal "${options_descriptions[:flag]}" "a flag"
    )
  end

  it "allows the creation of a string option defaulting to empty"
    (
    options.define "stropt" :string "" "a string" "s"
    # shellcheck disable=SC2154
    assert equal "${options[:stropt]}" ""
    assert equal "${options_descriptions[:stropt]}" "a string"
    )
  end

  it "allows the creation of a string option defaulting to \"sample\""
    (
    options.define "stropt" :string "sample" "a string" "s"
    # shellcheck disable=SC2154
    assert equal "${options[:stropt]}" "sample"
    assert equal "${options_descriptions[:stropt]}" "a string"
    )
  end
end

describe "options._get_getopt_options"
  it "returns an options string"
    (
    options.define "flag" :boolean 1 "a flag" "f"
    # shellcheck disable=SC2034
    getopt_options=""
    options._get_getopt_options :getopt_options
    assert equal $? 0
    assert equal "$getopt_options" "--options=f --long-options=flag"
    )
  end
end

describe "options._parse_getopt_options"
  it "feeds back a correct getopt result for a short-option boolean flag"
    (
    result=""
    getopt_options="--options=f"
    options._parse_getopt_options :result :getopt_options -- -f
    assert equal $? 0
    assert equal "$result" " -- '-f'"
    )
  end

  it "feeds back a correct getopt result for a long-option string"
    (
    result=""
    options._parse_getopt_options :result "--options= --longoptions=strval" -- --strval=example
    assert equal $? 0
    assert equal "$result" " -- '--strval=example'"
    )
  end
end

# describe "options.parse"
#   it "doesn't toggle a short-option boolean defaulting to false if not supplied"
#     (
#     options.define "flag" :boolean false "a flag" "f"
#     # shellcheck disable=SC2034
#     options.parse -c
#     # shellcheck disable=SC2154
#     assert equal "${options[:flag]}" 0
#     )
#   end
#
#   it "toggles a short-option boolean defaulting to false"
#     (
#     options.define "flag" :boolean false "a flag" "f"
#     # shellcheck disable=SC2034
#     options.parse -f
#     # shellcheck disable=SC2154
#     assert equal "${options[:flag]}" 1
#     )
#   end
#
#   it "toggles a long-option boolean defaulting to true"
#     (
#     options.define "flag" :boolean true "a flag" "f"
#     # shellcheck disable=SC2034
#     options.parse --flag
#     # shellcheck disable=SC2154
#     assert equal "${options[:flag]}" 0
#     )
#   end
#
#   it "toggles a short-option boolean defaulting to false"
#     (
#     options.define "flag" :boolean false "a flag" "f"
#     # shellcheck disable=SC2034
#     options.parse --flag
#     # shellcheck disable=SC2154
#     assert equal "${options[:flag]}" 1
#     )
#   end
#
#   it "toggles a long-option-only boolean defaulting to true"
#     (
#     options.define "flag" :boolean true "a flag"
#     # shellcheck disable=SC2034
#     options.parse --flag
#     # shellcheck disable=SC2154
#     assert equal "${options[:flag]}" 0
#     )
#   end
#
#   it "toggles a short-option boolean defaulting to true"
#     (
#     options.define "flag" :boolean true "a flag" "f"
#     # shellcheck disable=SC2034
#     options.parse -f
#     # shellcheck disable=SC2154
#     assert equal "${options[:flag]}" 0
#     )
#   end
# end
