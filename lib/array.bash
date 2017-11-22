# https://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value#answer-8574392
ary_contains () {
  local elem

  for elem in "${@:2}"; do
    [[ $elem == $1 ]] && return
  done
  return 1
}

ary_find () {
  local item=$1; shift
  local array=()
  local i

  array=( "$@" )
  for i in "${!array[@]}"; do
    [[ ${array[i]} == $item ]] && {
      echo "$i"
      return
    }
  done
  return 1
}

# https://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array#answer-17841619
ary_join () {
  local delim=$1; shift

  echo -n "$1"
  shift
  printf %s "${@/#/$delim}"
}

ary_remove () {
  local item=$1; shift
  local i
  local result=()

  for i in "$@"; do
    [[ $i == "$item" ]] || result+=( "$i" )
  done
  echo "${result[@]}"
}

ary_slice () {
  local first=$1; shift
  local last=$1;  shift
  local array=()
  local result

  array=( "$@" )
  echo "${array[@]:$first:$(( last - first + 1 ))}"
}
