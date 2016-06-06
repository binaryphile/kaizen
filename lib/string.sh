#!/usr/bin/env bash
# Functions for string testing and manipulation

str::split () {
  local array

  eval "IFS=\"$2\" read -ra array <<< \${$1}"
  echo "${array[@]}"
}

str::blank? ()            {   eval "[[ -z \$$1 ]] || [[ \$$1 =~ ^[[:space:]]+$ ]]" ;}
str::eql? ()              {   eval "[[ \$$1 == $2 ]]"  ;}
