#!/usr/bin/env bash
# Functions for platform-specific features

[[ -z $_bashlib_rhel_6 ]] || return 0

# shellcheck disable=SC2046,SC2155
declare -r _bashlib_rhel_6="$(set -- $(sha1sum "$BASH_SOURCE"); printf "%s" "$1")"

source "${BASH_SOURCE%/*}"/core.sh 2>/dev/null || source core.sh

dist.exit_if_package_is_installed() {
  ! package_is_installed "$1" || exit 0
}

dist.install_local_package() {
  sudo rpm -Uvh "$1"
}

dist.install_package() {
  local package

  package="$1"
  ! package_is_installed "$package" || return 0
  sudo yum install "$1"
}

dist.package_is_installed() {
  yum list installed "$1" >/dev/null
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
  sudo yum remove "$package"
}
