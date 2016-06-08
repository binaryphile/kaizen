#!/usr/bin/env bash
# Functions dealing with the shell or environment

# https://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts/12694189#12694189
[[ -d ${BASH_SOURCE%/*} ]] && _lib_dir="${BASH_SOURCE%/*}" || _lib_dir="${PWD}"

source "$_lib_dir"/core.sh
source "$_lib_dir"/upvar.sh

core.blank? _shell_loaded || return 0
# shellcheck disable=SC2034
declare -r _shell_loaded="true"

sh.deref() { core.deref "$@" ;}

# https://github.com/DinoTools/python-ssdeep/blob/master/ci/run.sh
# Normally this would be in distro but its a prerequisite to tell
# which distro library to load
sh.detect_os() {
  local os
  local version

  if is_on_filesystem "/etc/debian_version"; then
    os="$(head -1 </etc/issue | awk '{ print tolower($1) }')"
    if ! grep -q '/' /etc/debian_version; then
      version="$(cut -d. -f1 </etc/debian_version)"
    fi
    if is_empty "${version:-}" && is_on_filesystem "/etc/lsb-release"; then
      source /etc/lsb-release
      version="$(echo "${DISTRIB_RELEASE}" | cut -d. -f1)"
    fi
  elif is_on_filesystem "/etc/fedora-release"; then
    os="fedora"
    version="$(cut -f3 --delimiter=' ' /etc/fedora-release | cut -d. -f1)"
  elif is_on_filesystem "/etc/oracle-release"; then
    os="ol"
    version="$(cut -f5 --delimiter=' ' /etc/oracle-release)"
  elif is_on_filesystem "/etc/redhat-release"; then
    os="$(awk '{ print tolower($1) }' </etc/redhat-release | cut -d. -f1)"
    if is_match "${os}" "centos"; then
      version="$(awk '{ print $3 }' </etc/redhat-release | cut -d. -f1)"
    elif is_match "${os}" "scientific"; then
      version="$(awk '{ print $4 }' </etc/redhat-release | cut -d. -f1)"
    else
      version="$(awk '{ print tolower($7) }' </etc/redhat-release | cut -d. -f1)"
      os="rhel"
    fi
  fi
  echo "${os}-${version}"
}

sh.errexit_is_set()  {   [[ "$-" =~ e ]];            }
sh.exit_if_is_on_path() { ! is_on_path "$1" || exit "${2:-0}" ;}
sh.is_error()        { ! is_not_error "$1";          }
sh.is_not_error()    {   is_match "$1" "0";          }
sh.is_not_on_path()  { ! is_on_path "$1";            }
sh.is_on_path()      {   which "$1" >/dev/null 2>&1; }
sh.nounset_is_set()  { [[ "$-" =~ u ]];              }
sh.pop_dir()         { popd >/dev/null;              } # Not a file command, just CWD and environment vars
sh.push_dir()        { pushd "$1" >/dev/null;        }

sh.runas() {
  local user;
  user="$1";
  shift;
  sudo -su "${user}" BASH_ENV="~${user}/.bashrc" "$@"
}

sh.set_default() { eval "export $1=\${$1:-$2}"; }

sh.set_editor() {
  if is_file "/usr/bin/vim"; then
    printf "%s" "${EDITOR:-/usr/bin/vim}"
  elif is_file "/usr/bin/nano"; then
    printf "%s" "${EDITOR:-/usr/bin/nano}"
  else
    printf "%s" "${EDITOR:-}"
  fi
}

sh.set_pager() {
  if is_file "/usr/bin/less"; then
    printf "%s" "${PAGER:-/usr/bin/less}"
  else
    printf "%s" "${PAGER:-}"
  fi
}

sh.shell_is()      { [[ "${SHELL:-}" == "$1" ]]; }
sh.shell_is_bash() { shell_is "/bin/bash";       }

# http://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced#answer-14706745
sh.script_is_sourced() { [[ ${FUNCNAME[ (( ${#FUNCNAME[@]:-} - 1 ))]:-} == "source" ]]; }

sh.source_files_if_exist() {
  local filename

  for filename in "$@"; do
    is_not_file "${filename}" || source "${filename}"
  done
}

sh.source_relaxed() {
  local errexit
  local nounset

  is_file "$1" || return 0
  errexit_is_set && errexit="y"
  nounset_is_set && nounset="y"
  set +o errexit
  set +o nounset
  source "$1"
  ! is_empty "${errexit}" && set -o errexit
  ! is_empty "${nounset}" && set -o nounset
}

core.alias_function sh.strict_mode  core.strict_mode
core.alias_function sh.trace        core.trace
core.alias_function sh.value        core.value
