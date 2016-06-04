#!/usr/bin/env bash

exit_if_package_is_installed () {
  ! package_is_installed "$1" || exit 0
}

install_local_package () {
  sudo rpm -Uvh "$1"
}

install_package () {
  local package

  package="$1"
  ! package_is_installed "${package}" || return 0
  sudo yum install "$1"
}

package_is_installed () {
  yum list installed "$1" >/dev/null
}

reinstall_package () {
  local package

  package="$1"
  uninstall_package "${package}"
  install_package "${package}"
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
  local package

  package="$1"
  package_is_installed "${package}" || return 0
  sudo yum remove "${package}"
}
