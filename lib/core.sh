#!/usr/bin/env bash
# Functional programming style functions

[[ -z $_core_loaded ]] || return 0
declare -r _core_loaded="true"

cor::blank? ()  { eval "[[ -z \${$1:-} ]] || [[ \${$1:-} =~ ^[[:space:]]+$ ]]"  ;}
cor::eql? ()    { eval "[[ \${$1:-} == $2 ]]" ;}
