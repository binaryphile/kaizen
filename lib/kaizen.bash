source concorde.bash imports=''

set -o noglob

concorde::get <<'EOS'
  absolute_dirname=kaizen::absolute_dirname
  absolute_path=kaizen::absolute_path
  append_to_file=kaizen::append_to_file
  args?=kaizen::args?
  array=concorde::array
  arraynl=concorde::arraynl
  bring=concorde::bring
  contains?=kaizen::contains?
  die=concorde::die
  directory?=kaizen::directory?
  echoerr=concorde::echoerr
  ends_with?=kaizen::ends_with?
  executable?=kaizen::executable?
  executable_file?=kaizen::executable_file?
  false?=kaizen::false?
  file?=kaizen::file?
  get=concorde::get
  given?=kaizen::given?
  glob=kaizen::glob
  globbing=kaizen::globbing
  globbing?=kaizen::globbing?
  grab=concorde::grab
  grabkw=concorde::grabkw
  hash=concorde::hash
  hashkw=concorde::hashkw
  less_than?=kaizen::less_than?
  module=concorde::module
  more_than?=kaizen::more_than?
  nonexecutable_file?=kaizen::nonexecutable_file?
  parse_options=concorde::parse_options
  raise=concorde::raise
  sourced?=concorde::sourced
  starts_with?=kaizen::starts_with?
  strict_mode=concorde::strict_mode
  symlink?=kaizen::symlink?
  to_lower=kaizen::to_lower
  to_upper=kaizen::to_upper
  trim_from_last=kaizen::trim_from_last
  trim_to_last=kaizen::trim_to_last
  true?=kaizen::true?
  write_to_file=kaizen::write_to_file
EOS
concorde::constant imports="${__//$'\n'/ }"
__=__${__id_hsh[$BASH_SOURCE]}[imports]
case $1 in
  imports=  );;
  imports=* )
    set -- "${1//$'\n'/ }" "${@:2}"
    for __ in ${!__}; do
      [[ " ${1#imports=} " == *" ${__%%=*} "* ]] && eval "${__%%=*} () { ${__#*=} \"\$@\" ;}"
    done
    ;;
  * )
    for __ in ${!__}; do
      eval "${__%%=*} () { ${__#*=} \"\$@\" ;}"
    done
    ;;
esac

$(concorde::module kaizen)

concorde::get <<EOS
  basename='basename --'
  cd='cd --'
  chmod='chmod --'
  chmodtree='chmod -R --'
  cptree='cp --recursive --'
  dirname='dirname --'
  echo='printf %s\n'
  head='head --'
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

kaizen::absolute_dirname () {
  __=$(dirname -- "$1")
  kaizen::absolute_path "$__"
}

kaizen::absolute_path () {
  $(concorde::bring readlink from kaizen.commands)

  __=$($readlink "$1")
}

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
  [[ -n ${1:-} ]]
}

kaizen::glob () {
  local ary=()
  local noglob

  [[ $- != *f* ]] && noglob=$? || noglob=$?
  set +o noglob
  eval "ary=( $* )"
  (( noglob )) && set -o noglob
  concorde::repr_ary ary
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
