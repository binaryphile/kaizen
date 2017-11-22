# Let the user make a choice about something and execute code based on
# the answer
# Called like: choose <default (y or n)> <prompt>
# e.g. choose "y" \
#       "Do you want to play a game?" \
# Returns: 0 for yes and 1 for anything else
choose () {
  local default=$1
  local prompt=$2
  local answer

  read -ep "$prompt" answer
  is_empty "$answer" && answer=$default

  case $answer in
    [yY1] ) return 0;;
    *     ) return 1;;
  esac
}

# https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr#answer-2990533
echoerr () {
  cat <<<"$@" >&2;
}

default_flags () {
  DEFINE_boolean trace  false "enable tracing" t
  DEFINE_boolean strict true  "enable strict mode"
}

exec_flags () {
  is_match "$FLAGS_trace"   "$FLAGS_TRUE" && trace on
  is_match "$FLAGS_strict"  "$FLAGS_TRUE" && strict_mode on;:
}
