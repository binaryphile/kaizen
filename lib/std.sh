#!/usr/bin/env bash

# https://github.com/basecamp/sub/blob/master/libexec/sub
std::abs_dirname() {
  local cwd
  local path

  cwd="$(pwd)"
  path="$1"
  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(resolve_link "$name" || true)"
  done

  pwd
  cd "$cwd"
}

# https://onthebalcony.wordpress.com/2008/03/08/just-for-fun-map-as-higher-order-function-in-bash/
std::apply() {
  local f
  local x

  f="$1"
  x="$2"
  shift 2
  "${f}" "${x}"
  apply "${f}" "$@"
}

std::base_name() {
  echo "${1##*/}"
}

# https://github.com/DinoTools/python-ssdeep/blob/master/ci/run.sh
std::detect_os() {
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

std::errexit_is_set()                {   [[ "$-" =~ e ]];                              }
std::exit_if_is_directory()          { ! is_directory "$1"         || exit "${2:-0}";  }
std::exit_if_is_empty()              { ! is_empty "$1"             || exit "${2:-0}";  }
std::exit_if_is_file ()              { ! is_file "$1"              || exit "${2:-0}";  }
std::exit_if_is_link()               { ! is_link "$1"              || exit "${2:-0}";  }
std::exit_if_is_on_path()            { ! is_on_path "$1"           || exit "${2:-0}";  }
std::exit_if_package_is_installed()  { ! package_is_installed "$1" || exit "${2:-0}";  }
std::is_directory()                  {   [[ -d "$1" ]];                                }
std::is_empty()                      {   [[ -z "$1" ]];                                }
std::is_equal()                      {   [[ "$1" == "$2"  ]];                          }
std::is_error()                      { ! is_not_error "$1";                            }
std::is_file()                       {   [[ -f "$1" ]];                                }
std::is_link()                       {   [[ -h "$1" ]];                                }
std::is_match()                      {   is_equal "$1" "$2";                           }
std::is_not_directory()              { ! is_directory "$1";                            }
std::is_not_empty()                  { ! is_empty "$1";                                }
std::is_not_equal()                  { ! is_equal "$1" "$2";                           }
std::is_not_error()                  {   is_match "$1" "0";                            }
std::is_not_file()                   { ! is_file "$1";                                 }
std::is_not_match()                  { ! is_match "$1" "$2";                           }
std::is_not_older_than()             { ! [[ "$1" -ot "$2" ]];                          } # NOT the same as is_newer_than since they can be equal
std::is_not_on_path()                { ! is_on_path "$1";                              }
std::is_on_filesystem()              {   [[ -e "$1" ]];                                }
std::is_on_path()                    {   which "$1" >/dev/null 2>&1;                   }

std::load_config() {
  load_yml etc/defaults.yml
  ! is_empty "$1" || return 0
  load_yml "etc/$1"
}

std::load_yml()      { eval "$(parse_yml "$@")"; }
std::make_symlink()  { ln -sfT "$2" "$1";        }

std::make_group_dir() {
  sudo mkdir "$1"
  sudo chown "${USER}:${2:-prodadm}" "$1"
  chmod g+rwxs "$1"
  setfacl -m d:g::rwx "$1"
}

std::make_group_file() {
  sudo touch "$1"
  sudo chown "${USER}:${2:-prodadm}" "$1"
  chmod g+rw "$1"
}

std::nounset_is_set() { [[ "$-" =~ u ]]; }

std::parse_yml() {
  # http://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script#answer-21189044
  # parse a yml file into flattened variable names, concatenated with underscore
  # - argument allows specifying a prefix for the returned variables so they are namespaced
  # - eval the return value to set the variables globally, e.g.  "eval $(parse_yml filename)"
  # - does not handle yml lists, only dictionaries
  local prefix
  local fs
  local s
  local w

  prefix="$2"
  s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
  sed -ne "s|^\(${s}\):|\1|" \
    -e "s|^\(${s}\)\(${w}\)${s}:${s}[\"']\(.*\)[\"']${s}\$|\1$fs\2$fs\3|p" \
    -e "s|^\(${s}\)\(${w}\)${s}:${s}\(.*\)${s}\$|\1$fs\2$fs\3|p"  "$1" |
  awk -F"${fs}" '{
  indent = length($1)/2;
  vname[indent] = $2;
  for (i in vname) {if (i > indent) {delete vname[i]}}
    if (length($3) > 0) {
      vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
      printf("%s%s%s=\"%s\"\n", "'${prefix}'",vn, "$2", "$3");
    }
  }'
}

std::pop_dir()       { popd >/dev/null;                              }
std::push_dir()      { pushd "$1" >/dev/null;                        }
std::resolve_link()  { $(type -p greadlink readlink | head -1) "$1"; }

std::runas() {
  local user;
  user="$1";
  shift;
  sudo -su "${user}" BASH_ENV="~${user}/.bashrc" "$@"
}

std::set_default() { eval "export $1=\${$1:-$2}"; }

std::set_editor() {
  if is_file "/usr/bin/vim"; then
    printf "%s" "${EDITOR:-/usr/bin/vim}"
  elif is_file "/usr/bin/nano"; then
    printf "%s" "${EDITOR:-/usr/bin/nano}"
  else
    printf "%s" "${EDITOR:-}"
  fi
}

std::set_pager() {
  if is_file "/usr/bin/less"; then
    printf "%s" "${PAGER:-/usr/bin/less}"
  else
    printf "%s" "${PAGER:-}"
  fi
}

std::shell_is()      { [[ "${SHELL:-}" == "$1" ]]; }
std::shell_is_bash() { shell_is "/bin/bash";       }

# http://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced#answer-14706745
std::script_is_sourced() { [[ ${FUNCNAME[ (( ${#FUNCNAME[@]:-} - 1 ))]:-} == "source" ]]; }

std::source_files_if_exist() {
  local filename

  for filename in "$@"; do
    is_not_file "${filename}" || source "${filename}"
  done
}

std::source_relaxed() {
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

std::strict_mode () {
  case "$1" in
    "on" )
      set -o errexit
      set -o nounset
      set -o pipefail
      ;;
    "off" )
      set +o errexit
      set +o nounset
      set +o pipefail
      ;;
  esac
}

std::substitute_in_file() { sed -i -e "s|$2|$3|" "$1"; }

std::trace() {
  case "$1" in
    "on" )
      set -o xtrace
      ;;
    "off" )
      set +o xtrace
      ;;
  esac
}

std::usage_and_exit_if_is_empty() {
  if is_empty "$1"; then
    usage
    exit 1
  fi
}
