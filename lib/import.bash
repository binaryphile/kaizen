[[ -n $_kzn_import ]] && return
readonly _kzn_import=loaded

source sorta.bash

_required_imports=(
  _imp_test
)

_imp_test() { :;}

importa() {(
  eval "$(passed '( _sourcefile @_functions )' "$@")"
  local _function

  _source_file _sourcefile
  _functions=( "${_required_imports[@]}" "${_functions[@]}" )
  for _function in "${_functions[@]}"; do
    _print_function _function
  done
)}

imports() (
  eval "$(passed '( sourcefile function )' "$@")"

  importa sourcefile '( '"$function"' )'
)

_print_function() {(
  eval "$(passed '( function )' "$@")"

  IFS=$'\n'
  set -- $(type "$function")
  shift
  printf '%s\n' "$*"
)}

_source_file() {
  eval "$(passed '( sourcefile )' "$@")"

  source ./"$sourcefile".bash 2>/dev/null ||
    source ./"$sourcefile".sh 2>/dev/null ||
    source "$sourcefile".bash 2>/dev/null ||
    source "$sourcefile".sh 2>/dev/null
}
