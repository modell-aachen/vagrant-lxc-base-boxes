#!/bin/bash
set -e

source /etc/profile

echo 'Installing extra packages and upgrading'

PACKAGES=(vim curl wget man-db openssh-server bash-completion ca-certificates sudo)

echo "Installing additional packages: ${ADDPACKAGES}"
PACKAGES+=" ${ADDPACKAGES}"

if [ $DISTRIBUTION = 'ubuntu' ]; then
  PACKAGES+=' software-properties-common'
fi

ANSIBLE=${ANSIBLE:-0}
if [[ $ANSIBLE = 1 ]]; then
    PACKAGES+=' ansible'
fi

CHEF=${CHEF:-0}
if [[ $CHEF = 1 ]]; then
    PACKAGES+=' chef'
fi

PUPPET=${PUPPET:-0}
if [[ $PUPPET = 1 ]]; then
    PACKAGES+=' puppet'
fi

SALT=${SALT:-0}
if [[ $SALT = 1 ]]; then
    PACKAGES+=' salt-minion'
fi

export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
apt-get update
apt-get install ${PACKAGES[*]} -y --force-yes
apt-get upgrade -y --force-yes


if [ $DISTRIBUTION = 'debian' ]; then
  # Enable bash-completion
  sed -e '/^#if ! shopt -oq posix; then/,/^#fi/ s/^#\(.*\)/\1/g' \
    -i /etc/bash.bashrc
fi
