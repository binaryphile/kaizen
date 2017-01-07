[[ -n $_kzn_import ]] && return
readonly _kzn_import=loaded

source sorta.bash

importa() (
  eval "$(passed '( sourcefile @functions )' "$@")"

  source_file sourcefile
  for function in "${functions[@]}"; do
    results+=( "$(print_function function)" )
  done
  IFS=$'\n'
  printf '%s\n' "${results[*]}"
)

imports() (
  eval "$(passed '( sourcefile function )' "$@")"

  source_file sourcefile
  print_function function
)

print_function() (
  eval "$(passed '( function )' "$@")"

  IFS=$'\n'
  set -- $(type "$function")
  shift
  printf '%s\n' "$*"
)

source_file() {
  eval "$(passed '( sourcefile )' "$@")"

  source ./"$sourcefile".bash 2>/dev/null ||
    source ./"$sourcefile".sh 2>/dev/null ||
    source "$sourcefile".bash 2>/dev/null ||
    source "$sourcefile".sh 2>/dev/null
}
