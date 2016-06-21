#!/usr/bin/env bash

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -n $_bl_lib_dir ]] || {
  if [[ -d ${BASH_SOURCE%/*} ]]; then
    _bl_lib_dir="${BASH_SOURCE%/*}/.."
  else
    _bl_lib_dir="$PWD/.."
  fi
}

[[ -n $RUBSH_PATH ]] || export RUBSH_PATH="$_bl_lib_dir"
source "$_bl_lib_dir"/rubsh/rubsh.sh

require "core"

String.blank? _bl_rhel_6_loaded || return 0
# shellcheck disable=SC2034
declare -r _bl_rhel_6_loaded="true"

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
