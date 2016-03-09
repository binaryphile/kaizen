#!/usr/bin/env bash
# vim: ft=sh

source lib/stdlib

describe "run_in_directory"
  it "evals properly"
    sample=( hello "there  you" )
    target="hello there  you"
    result=$(run_in_directory "${HOME}" "echo" "${sample[@]}")
    assert equal "${target}" "${result}"
  end
end
