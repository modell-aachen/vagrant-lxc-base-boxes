#!/bin/bash
set -e

source /etc/profile

echo 'Installing packages and upgrading'

PACKAGES=(vim net-misc/curl wget man-db openssh bash-completion ca-certificates sudo)

echo "Installing additional packages: ${ADDPACKAGES}"
PACKAGES+=" ${ADDPACKAGES}"

ANSIBLE=${ANSIBLE:-0}
if [[ $ANSIBLE = 1 ]]; then
    PACKAGES+=' ansible'
fi

CHEF=${CHEF:-0}
if [[ $CHEF = 1 ]]; then
    echo "Chef installation isn't supported on Gentoo"
    exit 1
fi

PUPPET=${PUPPET:-0}
if [[ $PUPPET = 1 ]]; then
    PACKAGES+=' puppet'
fi

SALT=${SALT:-0}
if [[ $SALT = 1 ]]; then
    PACKAGES+=' salt'
fi

# trying to set capabilities on an unprivileged container fails.
echo "net-misc/iputils -filecaps" > /etc/portage/package.use/vagrant_overrides

emerge --sync
emerge --noreplace ${PACKAGES[*]}
emerge -uND @world
