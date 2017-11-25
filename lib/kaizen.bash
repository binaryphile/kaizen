source concorde.bash
$(feature kaizen)

set -o noglob

get <<'EOS'
  append_to_file
  args
  contains
  directory
  ends_with
  executable
  executable_file
  false
  file
  given
  glob
  globbing
  less_than
  more_than
  nonexecutable_file
  sourced
  starts_with
  symlink
  trim_from_last
  trim_to_last
  true
  write_to_file
EOS
for __ in $__; do
  constant "$__=kaizen::$__"
done

kaizen::append_to_file () {
  put "$2" >>"$1"
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
  repr ary
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
  put "$2" >"$1"
}
