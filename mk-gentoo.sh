#!/bin/bash
set -e

source common/ui.sh
source common/utils.sh

TODAY=$(date -u +"%Y-%m-%d")
export DISTRIBUTION=gentoo
export RELEASE=current
export ARCH=$(uname -m | sed -e "s/68/38/" | sed -e "s/x86_64/amd64/")
export CONTAINER="vagrant-base-${DISTRIBUTION}-${ARCH}"
export PACKAGE="output/${TODAY}/${CONTAINER}.box"
export NOW=$(date -u)

echo '############################################'
echo "# Beginning build at $(date)"

if [ -f ${PACKAGE} ]; then
  warn "The box '${PACKAGE}' already exists, skipping..."
  echo
  exit
fi

info "Building box to '${PACKAGE}'..."

./common/download.sh
utils.lxc.start

SECS=15
log "Sleeping for $SECS seconds..."
sleep $SECS

utils.lxc.runscript gentoo/install-packages.sh
utils.lxc.runscript common/prepare-vagrant-user.sh
utils.lxc.runscript gentoo/clean.sh
utils.lxc.stop

./common/package.sh

info "Finished building '${PACKAGE}'!"
log "Run \`lxc-destroy -n ${CONTAINER}\` or \`make clean\` to remove the container that was created along the way"
echo
