source stdlib

exit_if_package_is_installed () {
  package_is_installed "$1" && exit
}

install_local_package () {
  sudo dpkg -i "$1"
}

install_package () {
  package_is_installed "$1" && return
  update_apt
  sudo apt-get install "$1"
}

package_is_installed () {
  dpkg --get-selections "$1" 2>/dev/null | grep -q "^$1\\(:amd64\\)\\?[[:space:]]\\+install\$" >/dev/null
}

reinstall_package () {
  uninstall_package "$1"
  install_package "$1"
}

start_service () {
  sudo service "$1" start
}

stop_service () {
  sudo service "$1" stop
}

reload_service () {
  sudo service "$1" reload
}

uninstall_package () {
  ! package_is_installed "$1" && return
  sudo apt-get purge "$1"
}

update_apt () {
  local apt_date
  local last_update
  local now_date
  local update_interval

  apt_date=$(stat -c %Y /var/cache/apt/pkgcache.bin)
  now_date=$(date +%s)
  last_update=$(( now_date - apt_date ))
  update_interval=$(( 24 * 60 * 60 ))
  (( last_update > update_interval )) && sudo apt-get update -qq;:
}
