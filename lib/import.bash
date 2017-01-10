[[ -n $_kzn_import ]] && return
readonly _kzn_import=loaded

source sorta.bash

_required_imports=(
  _imp_test
)

_imp_test() { :;}

importa() (
  eval "$(passed '( sourcefile @functions )' "$@")"
  local function

  functions=( "${_required_imports[@]}" "${functions[@]}" )
  source_file sourcefile
  for function in "${functions[@]}"; do
    print_function function
  done
)

imports() (
  eval "$(passed '( sourcefile function )' "$@")"

  importa sourcefile '( '"$function"' )'
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
