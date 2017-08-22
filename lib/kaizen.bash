source concorde.bash
$(feature kaizen)

set -o noglob

stuff '(
  directory?
  executable?
  file?
)' intons kaizen.dependencies

args?               () { (( $# ))     ;}
directory?          () { [[ -d $1 ]]  ;}
executable?         () { [[ -x $1 ]]  ;}
executable_file?    () { file? "$1"   &&   executable? "$1" ;}
file?               () { [[ -f $1 ]]  ;}
length?             () { (( $#    ))  ;}
nonexecutable_file? () { file? "$1"   && ! executable? "$1" ;}
