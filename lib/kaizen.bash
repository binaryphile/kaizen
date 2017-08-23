set -o noglob

source concorde.bash
$(feature kaizen)

kaize_attrs () {
  local dependencies

  dependencies='(
    directory?
    executable?
    file?
  )'
  stuff dependencies intons kaizen
}

args?               () { (( $# ))     ;}
directory?          () { [[ -d $1 ]]  ;}
executable?         () { [[ -x $1 ]]  ;}
executable_file?    () { file? "$1"   &&   executable? "$1" ;}
file?               () { [[ -f $1 ]]  ;}
length?             () { (( $#    ))  ;}
nonexecutable_file? () { file? "$1"   && ! executable? "$1" ;}
trim_to_last        () { __=${2##*$1} ;}

kaize_attrs
unset -f kaize_attrs
