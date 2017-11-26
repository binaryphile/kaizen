source concorde.bash

set -o noglob

concorde::get <<'EOS'
  append_to_file=kaizen::append_to_file
  args=kaizen::args
  array=concorde::array
  arraynl=concorde::arraynl
  bring=concorde::bring
  contains=kaizen::contains
  directory=kaizen::directory
  ends_with=kaizen::ends_with
  executable=kaizen::executable
  executable_file=kaizen::executable_file
  false=kaizen::false
  file=kaizen::file
  get=concorde::get
  given=kaizen::given
  glob=kaizen::glob
  globbing=kaizen::globbing
  grabkw=concorde::grabkw
  hash=concorde::hash
  hashkw=concorde::hashkw
  less_than=kaizen::less_than
  module=concorde::module
  more_than=kaizen::more_than
  nonexecutable_file=kaizen::nonexecutable_file
  sourced=kaizen::sourced
  starts_with=kaizen::starts_with
  strict_mode=concorde::strict_mode
  symlink=kaizen::symlink
  to_lower=kaizen::to_lower
  to_upper=kaizen::to_upper
  trim_from_last=kaizen::trim_from_last
  trim_to_last=kaizen::trim_to_last
  true=kaizen::true
  write_to_file=kaizen::write_to_file
EOS
for __ in $__; do
  [[ -n ${1:-} ]] && {
    [[ $1 == all=1 || " ${1#globals=} " == *" ${__%%=*} "* ]] && eval "declare -g $__"
  }
  concorde::constant "$__"
done

$(concorde::module kaizen)

concorde::get <<EOS
  basename='basename --'
  cptree='cp --recursive --'
  dirname='dirname --'
  install='install -bm 644 --'
  installd='install -dm 755 --'
  installx='install -bm 755 --'
  ln='ln --symbolic --force --'
  mkdir='mkdir --parents --'
  mktemp='mktemp --quiet --'
  mktempd='mktemp --quiet --directory --'
  readlink="$(type greadlink >/dev/null 2>&1 && echo 'greadlink -f --' || echo 'readlink -f --')"
  rmdir='rmdir --'
  rmtree='rm --recursive --force --'
  rm='rm --force --'
  sed='sed -i.bak'
  touch='touch --'
EOS
concorde::constant commands="${__//$'\n'/ }"

kaizen::append_to_file () {
  printf %s "$2" >>"$1"
}

kaizen::args? () {
  (( $# ))
}

kaizen::contains? () {
  [[ $2 == *"$1"* ]]
}

kaizen::directory? () {
  [[ -d $1 ]]
}

kaizen::ends_with? () {
  [[ $2 == *$1 ]]
}

kaizen::executable? () {
  [[ -x $1 ]]
}

kaizen::executable_file? () {
  kaizen::file? "$1" && kaizen::executable? "$1"
}

kaizen::false? () {
  ! (( ${!1:-} ))
}

kaizen::file? () {
  [[ -f $1 ]]
}

kaizen::given? () {
  [[ -n ${!1:-} ]]
}

kaizen::glob () {
  local ary=()
  local status

  [[ $- == *f* ]] && status=- || status=+
  set +o noglob
  eval "ary=( $* )"
  eval "set ${status}o noglob"
  concorde::repr ary
}

kaizen::globbing () {
  case $1 in
    on  ) set +o noglob ;;
    off ) set -o noglob ;;
    *   ) return 1      ;;
  esac
}

kaizen::globbing? () {
  [[ $- != *f* ]]
}

kaizen::less_than? () {
  (( ($# - 1) < $1 ))
}

kaizen::more_than? () {
  (( ($# - 1) > $1 ))
}

kaizen::nonexecutable_file? () {
  kaizen::file? "$1" && ! kaizen::executable? "$1"
}

kaizen::starts_with? () {
  [[ $2 == $1* ]]
}

kaizen::sourced? () {
  [[ ${FUNCNAME[1]} == source ]]
}

kaizen::symlink? () {
  [[ -h $1 ]]
}

kaizen::to_lower () {
  __=${1,,}
}

kaizen::to_upper () {
  __=${1^^}
}

kaizen::trim_from_last () {
  __=${2%$1*}
}

kaizen::trim_to_last () {
  __=${2##*$1}
}

kaizen::true? () {
  (( ${!1:-} ))
}

kaizen::write_to_file () {
  printf %s "$2" >"$1"
}
