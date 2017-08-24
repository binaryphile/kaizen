set -o noglob

source concorde.bash
$(feature kaizen)

kaizen_init () {
  local dependencies

  dependencies='(
    executable?
    file?
    sourced
  )'
  stuff dependencies intons kaizen
}

args?               () { (( $# ))     ;}
contains?           () { [[ ${2:-} == *"${1:-}"* ]]         ;}
directory?          () { [[ -d $1 ]]  ;}
executable?         () { [[ -x $1 ]]  ;}
executable_file?    () { file? "$1"   &&   executable? "$1" ;}
file?               () { [[ -f $1 ]]  ;}
length?             () { (( $#    ))  ;}
nonexecutable_file? () { file? "$1"   && ! executable? "$1" ;}
sourced?            () { sourced "$@" ;}
trim_from_last      () { __=${2%$1*}  ;}
trim_to_last        () { __=${2##*$1} ;}

kaizen_init
