source stdlib

exit_if_package_is_installed () {
  package_is_installed "$1" && exit
}

install_local_package () {
  sudo rpm -Uvh "$1"
}

install_package () {
  package_is_installed "$1" && return
  sudo yum -y install "$1"
}

package_is_installed () {
  yum list installed "$1" >/dev/null
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
  sudo yum remove "$1"
}
