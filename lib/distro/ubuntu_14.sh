#!/usr/bin/env bash

dst.exit_if_package_is_installed () {
  ! package_is_installed "$1" || exit 0
}

dst.install_local_package () {
  sudo dpkg -i "$1"
}

dst.install_package () {
  local package

  package="$1"
  ! package_is_installed "${package}" || return 0
  update_apt
  sudo apt-get install "${package}"
}

dst.package_is_installed () {
  dpkg --get-selections "$1" 2>/dev/null | grep -q "^$1\\(:amd64\\)\\?[[:space:]]\\+install\$" >/dev/null
}

dst.reinstall_package () {
  local package

  package="$1"
  uninstall_package "${package}"
  install_package "${package}"
}

dst.start_service () {
  sudo service "$1" start
}

dst.stop_service () {
  sudo service "$1" stop
}

dst.reload_service () {
  sudo service "$1" reload
}

dst.uninstall_package () {
  local package

  package="$1"
  package_is_installed "${package}" || return 0
  sudo apt-get purge "${package}"
}

dst.update_apt () {
  local apt_date
  local now_date
  local last_update
  local update_interval

  apt_date="$(stat -c %Y '/var/cache/apt/pkgcache.bin')"
  now_date="$(date +'%s')"
  last_update="$((now_date - apt_date))"
  update_interval="$((24 * 60 * 60))"
  [[ "${last_update}" -lt "${update_interval}" ]] || sudo apt-get update -qq
}
