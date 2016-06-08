#!/usr/bin/env bash

dst.exit_if_package_is_installed() {
  ! package_is_installed "$1" || exit 0
}

dst.install_local_package() {
  sudo rpm -Uvh "$1"
}

dst.install_package() {
  local package

  package="$1"
  ! package_is_installed "$package" || return 0
  sudo yum install "$1"
}

dst.package_is_installed() {
  yum list installed "$1" >/dev/null
}

dst.reinstall_package() {
  local package

  package="$1"
  uninstall_package "$package"
  install_package "$package"
}

dst.start_service() {
  sudo service "$1" start
}

dst.stop_service() {
  sudo service "$1" stop
}

dst.reload_service() {
  sudo service "$1" reload
}

dst.uninstall_package() {
  local package

  package="$1"
  package_is_installed "$package" || return 0
  sudo yum remove "$package"
}
