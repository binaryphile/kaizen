# https://github.com/basecamp/sub/blob/master/libexec/sub
abs_dirname() { (
  local path=$1
  local name

  while [[ -n "$path" ]]; do
    cd "${path%/*}"
    name=${path##*/}
    path=$(resolve_link "$name") ||:
  done
  pwd
) }

# https://onthebalcony.wordpress.com/2008/03/08/just-for-fun-map-as-higher-order-function-in-bash/
apply () {
  local f=$1
  local x=$2
  shift 2

  "$f" "$x"
  apply "$f" "$@"
}

base_name () {
  echo "${1##*/}"
}

# https://github.com/DinoTools/python-ssdeep/blob/master/ci/run.sh
detect_os () {
  local os
  local version

  if is_on_filesystem /etc/debian_version; then
    os=$(cat /etc/issue | head -1 | awk '{ print tolower($1) }')
    if ! grep -q / /etc/debian_version; then
      version=$(cat /etc/debian_version | cut -d. -f1)
    fi
    if is_empty "${version:-}" && is_on_filesystem /etc/lsb-release; then
      source /etc/lsb-release
      version=$(echo ${DISTRIB_RELEASE} | cut -d. -f1)
    fi
  elif is_on_filesystem /etc/fedora-release; then
    os=fedora
    version=$(cut -f3 --delimiter=' ' /etc/fedora-release | cut -d. -f1)
  elif is_on_filesystem /etc/oracle-release; then
    os=ol
    version=$(cut -f5 --delimiter=' ' /etc/oracle-release)
  elif is_on_filesystem /etc/redhat-release; then
    os=$(cat /etc/redhat-release  | awk '{ print tolower($1) }' | cut -d. -f1)
    if is_match "$os" centos; then
      version=$(cat /etc/redhat-release | awk '{ print $3 }' | cut -d. -f1)
    elif is_match "$os" scientific; then
      version=$(cat /etc/redhat-release | awk '{ print $4 }' | cut -d. -f1)
    else
      version=$(cat /etc/redhat-release  | awk '{ print tolower($7) }' | cut -d. -f1)
      os=rhel
    fi
  fi
  echo "$os-$version"
}

errexit_is_set () {
  [[ $- == *e* ]]
}

exit_if_is_directory () {
  is_directory "$1" && exit
}

exit_if_is_empty () {
  is_empty "$1" && exit
}

exit_if_is_file () {
  is_file "$1" && exit
}

exit_if_is_link () {
  is_link "$1" && exit
}

exit_if_is_on_path () {
  is_on_path "$1" && exit
}

exit_if_package_is_installed () {
  package_is_installed "$1" && exit
}

is_directory () {
  [[ -d $1 ]]
}

is_empty () {
  [[ -z $1 ]]
}

is_error () {
  (( $1 ))
}

is_file () {
  [[ -e $1 ]]
}

is_link () {
  [[ -h $1 ]]
}

is_match () {
  [[ $1 == "$2" ]]
}

is_not_empty () {
  ! is_empty "$1"
}

is_not_error () {
  ! (( $1 ))
}

is_not_file () {
  [[ ! -e $1 ]]
}

is_not_directory () {
  [[ ! -d $1 ]]
}

is_not_match () {
  [[ $1 != "$2" ]]
}

is_not_on_path () {
  ! which "$1" >/dev/null 2>&1
}

is_on_filesystem () {
  [[ -e $1 ]]
}

is_on_path () {
  which "$1" >/dev/null 2>&1
}

load_config () {
  load_yml etc/defaults.yml
  is_empty "$1" && return
  load_yml etc/"$1"
}

load_yml () {
  eval "$(parse_yml "$@")"
}

make_symlink () {
  ln -sfT "$2" "$1"
}

make_group_dir () {
  sudo mkdir "$1"
  sudo chown "$USER:${2:-prodadm}" "$1"
  chmod g+rwxs "$1"
  setfacl -m d:g::rwx "$1"
}

make_group_file () {
  sudo touch "$1"
  sudo chown "$USER:${2:-prodadm}" "$1"
  chmod g+rw "$1"
}

nounset_is_set () {
  [[ $- == *u* ]]
}

parse_yml () {
  # http://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script#answer-21189044
  # parse a yml file into flattened variable names, concatenated with underscore
  # - argument allows specifying a prefix for the returned variables so they are namespaced
  # - eval the return value to set the variables globally, e.g.  "eval $(parse_yml filename)"
  # - does not handle yml lists, only dictionaries
  local prefix=$2
  local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
  sed -ne "s|^\($s\):|\1|" \
    -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
    -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
  awk -F$fs '{
  indent = length($1)/2;
  vname[indent] = $2;
  for (i in vname) {if (i > indent) {delete vname[i]}}
    if (length($3) > 0) {
      vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
      printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
    }
  }'
}

pop_dir () {
  popd >/dev/null
}

push_dir () {
  pushd "$1" >/dev/null
}

resolve_link () {
  $(type -p greadlink readlink | head -1) "$1"
}

runas () {
  local user=$1; shift

  sudo -su "$user" BASH_ENV="~$user/.bashrc" "$@"
}

set_default () {
  eval "export $1=\${$1:-$2}"
}

set_editor () {
  local editor=''

  [[ -n ${EDITOR:-} ]]  && { echo "$EDITOR"; return ;}
  is_file /usr/bin/nano && editor=/usr/bin/nano
  is_file /usr/bin/vim  && editor=/usr/bin/vim
  echo "$editor"
}

set_pager () {
  is_file /usr/bin/less && echo ${PAGER:-/usr/bin/less} || echo "${PAGER:-}"
}

shell_is () {
  [[ ${SHELL:-} == "$1" ]]
}

shell_is_bash () {
  shell_is /bin/bash
}

# http://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced#answer-14706745
script_is_sourced () {
  [[ ${FUNCNAME[(( ${#FUNCNAME[@]:-} - 1 ))]:-} == source ]]
}

source_relaxed () {
  local errexit
  local nounset

  is_not_file "$1"  && return
  errexit_is_set    && errexit=y
  nounset_is_set    && nounset=y
  set +o errexit
  set +o nounset
  source "$1"
  is_not_empty "$errexit" && set -o errexit
  is_not_empty "$nounset" && set -o nounset
}

strict_mode () {
  case $1 in
    on )
      set -o errexit
      set -o nounset
      set -o pipefail
      ;;
    off )
      set +o errexit
      set +o nounset
      set +o pipefail
      ;;
  esac
}

substitute_in_file () {
  sed -i -e "s|$2|$3|" "$1"
}

trace () {
  case $1 in
    on  ) set -o xtrace;;
    off ) set +o xtrace;;
  esac
}

usage_and_exit_if_is_empty () {
  if is_empty "$1"; then
    usage
    exit
  fi
}
