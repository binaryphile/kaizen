#!/usr/bin/env bash
# vim: ft=sh

source lib/stdlib

describe "in_directory"
  it "evals properly"
    sample=( hello "there  you" )
    target="hello there  you"
    result=$(in_directory "${HOME}" "echo" "${sample[@]}")
    assert equal "${target}" "${result}"
  end
end
