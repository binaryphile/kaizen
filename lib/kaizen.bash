set -o noglob

source concorde.bash
$(feature kaizen)

kaizen_init () {
  local dependencies

  dependencies='(
    executable?
    file?
  )'
  stuff dependencies intons kaizen
}

append_to_file      () { put "$2" >>"$1"                  ;}
args?               () { (( $# ))                         ;}
contains?           () { [[ $2 == *"$1"* ]]               ;}
directory?          () { [[ -d $1 ]]                      ;}
ends_with?          () { [[ ${2:-} == *${1:-} ]]          ;}
executable?         () { [[ -x $1 ]]                      ;}
executable_file?    () { file? "$1" &&   executable? "$1" ;}
file?               () { [[ -f $1 ]]                      ;}
less_than?          () { (( ($# - 1) < $1 ))              ;}
more_than?          () { (( ($# - 1) > $1 ))              ;}
nonexecutable_file? () { file? "$1" && ! executable? "$1" ;}
sourced?            () { [[ ${FUNCNAME[1]} == 'source' ]] ;}
trim_from_last      () { __=${2%$1*}                      ;}
trim_to_last        () { __=${2##*$1}                     ;}

kaizen_init
