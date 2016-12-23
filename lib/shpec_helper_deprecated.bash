make_temp_dir() {
  local base_dir="${1:-"${TMPDIR:-/tmp}"}"

  result=$(mktemp -d "$base_dir/tmpdir.XXXXXX") || return

  echo "$result"
}

make_temp_file() {
  local base_dir="${1:-"${TMPDIR:-/tmp}"}"
  local result

  result=$(mktemp "$base_dir/file.XXXXXX") || return

  echo "$result"
}
