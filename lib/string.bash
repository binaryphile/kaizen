str_split () {
  echo $( IFS="$1"; read -a array <<< "$2"; echo "${array[@]}" )
}