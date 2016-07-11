#!/usr/bin/env bash
# Functions for platform-specific features

[[ -z $_bashlib_ubuntu_14 ]] || return 0

# shellcheck disable=SC2046,SC2155
declare -r _bashlib_ubuntu_14="$(set -- $(sha1sum "$BASH_SOURCE"); printf "%s" "$1")"

source "${BASH_SOURCE%/*}"/core.sh 2>/dev/null || source core.sh

dist.exit_if_package_is_installed() {
  ! package_is_installed "$1" || exit 0
}

dist.install_local_package() {
  sudo dpkg -i "$1"
}

dist.install_package() {
  local package

  package="$1"
  ! package_is_installed "$package" || return 0
  update_apt
  sudo apt-get install "$package"
}

dist.package_is_installed() {
  dpkg --get-selections "$1" 2>/dev/null | grep -q "^$1\\(:amd64\\)\\?[[:space:]]\\+install\$" >/dev/null
}

dist.reinstall_package() {
  local package

  package="$1"
  uninstall_package "$package"
  install_package "$package"
}

dist.start_service() {
  sudo service "$1" start
}

dist.stop_service() {
  sudo service "$1" stop
}

dist.reload_service() {
  sudo service "$1" reload
}

dist.uninstall_package() {
  local package

  package="$1"
  package_is_installed "$package" || return 0
  sudo apt-get purge "$package"
}

dist.update_apt() {
  local apt_date
  local now_date
  local last_update
  local update_interval

  apt_date="$(stat -c %Y '/var/cache/apt/pkgcache.bin')"
  now_date="$(date +'%s')"
  last_update="$((now_date - apt_date))"
  update_interval="$((24 * 60 * 60))"
  [[ $last_update -lt $update_interval ]] || sudo apt-get update -qq
}
