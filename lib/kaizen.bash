source concorde.bash
$(feature kaizen)

set -o noglob

stuff '(
  directory?
  executable?
  file?
)' intons kaizen.dependencies

# absolute_path () {
#   eval "$(passed '( path )' "$@")"
#   local filename
#
#   unset -v CDPATH
#   is_file path && {
#     filename=$(basename path)
#     path=$(dirname path)
#   }
#   is_directory path || return
#   path=$(cd "$path"; pwd) || return
#   puts "$path${filename:+/}${filename:-}"
# }

args? () { (( $# )) ;}

# basename () {
#   eval "$(passed '( path )' "$@")"
#
#   puts "${path##*/}"
# }
#
# defa () { eval "$(printf '%s=()' "$1")"; geta "$1"; stripa "$1" ;}
#
# defs () {
#   local -a _results
#   local IFS
#
#   defa _results
#   IFS=$'\n'
#   printf -v "$1" '%s' "${_results[*]}"
# }
#
# dirname () {
#   eval "$(passed '( path )' "$@")"
#
#   if [[ $path == */* ]]; then
#     puts "${path%/?*}"
#   else
#     puts .
#   fi
# }
#
# errexit () {
#   eval "$(passed '( message return_code=1)' "$@")"
#
#   putserr message
#   exit "$return_code"
# }
#
# geta () {
#   while IFS= read -r; do
#     eval "$(printf '%s+=( %q )' "$1" "$REPLY")"
#   done
# }
#
# has_length () {
#   eval "$(passed '( length @array )' "$@")"
#
#   (( length == ${#array[@]} ))
# }

directory?          () { [[ -d $1 ]]  ;}
executable?         () { [[ -x $1 ]]  ;}
executable_file?    () { file? "$1"   &&   executable? "$1" ;}
file?               () { [[ -f $1 ]]  ;}
length?             () { (( $#    ))  ;}
nonexecutable_file? () { file? "$1"   && ! executable? "$1" ;}

# is_given () {
#   local declaration
#
#   declaration=$(declare -p "$1" 2>/dev/null) || return
#   [[ $declaration != *'=""' && $declaration != *"='()'" ]]
# }
#
# is_same_as () {
#   eval "$(passed '( string1 string2 )' "$@")"
#
#   [[ $string1 == "$string2" ]]
# }
#
# is_set () { declare -p "$1" >/dev/null 2>&1 ;}
#
# is_symlink () {
#   eval "$(passed '( path )' "$@")"
#
#   [[ -h $path ]]
# }
#
# joina () {
#   eval "$(passed '( delimiter @array )' "$@")"
#   local IFS
#
#   set -- "${array[@]}"
#   IFS=$delimiter
#   puts "${array[*]}"
# }
#
# puts () {
#   eval "$(passed '( message )' "$@")"
#
#   printf '%s\n' "$message"
# }
#
# putserr () {
#   eval "$(passed '( message )' "$@")"
#
#   puts message >&2
# }
#
# splits () {
#   eval "$(passed '( delimiter string "*refa" )' "$@")"
#   local IFS
#   local results=()
#
#   IFS=$delimiter
#   set -- $string
#   results=( "$@" )
#   local "$refa" && ret results "$refa"
# }
#
# starts_with () {
#   eval "$(passed '( prefix string )' "$@")"
#
#   [[ $string == "$prefix"* ]]
# }
#
# strict_mode () {
#   eval "$(passed '( status )' "$@")"
#
#   case $status in
#     on )
#       set -o errexit
#       set -o nounset
#       set -o pipefail
#       ;;
#     off )
#       set +o errexit
#       set +o nounset
#       set +o pipefail
#       ;;
#   esac
# }
#
# stripa () {
#   eval "$(passed '( "&_ref" )' "$@")"
#   local _i
#   local _leading_whitespace
#   local _len
#
#   _leading_whitespace=${_ref[0]%%[^[:space:]]*}
#   _len=${#_leading_whitespace}
#   for _i in "${!_ref[@]}"; do
#     printf -v _ref[$_i] '%s' "${_ref[$_i]:$_len}"
#   done
# }
#
# to_lower () {
#   eval "$(passed '( string )' "$@")"
#
#   puts "${string,,}"
# }
#
# to_upper () {
#   eval "$(passed '( string )' "$@")"
#
#   puts "${string^^}"
# }
