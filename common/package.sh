#!/bin/bash
set -e

source common/ui.sh

ROOTFS="${HOME}/.local/share/lxc/${CONTAINER}/rootfs"
WORKING_DIR="/tmp/${CONTAINER}"

debug "Creating ${WORKING_DIR}"
mkdir -p ${WORKING_DIR}
mkdir -p $(dirname ${PACKAGE})

# TODO: Create file with build date / time on container

info "Packaging '${CONTAINER}' to '${PACKAGE}'..."

if [ -f ${WORKING_DIR}/rootfs.tar.gz ]; then
  log "Removing previous rootfs tarball"
  rm -f ${WORKING_DIR}/rootfs.tar.gz
fi

log "Compressing container's rootfs (sudo needed)"
pushd  $(dirname ${ROOTFS})
  sudo tar --numeric-owner --anchored --exclude=./rootfs/dev/log -czf \
      ${WORKING_DIR}/rootfs.tar.gz ./rootfs/*
popd
sudo chown ${UID} ${WORKING_DIR}/rootfs.tar.gz

# Prepare package contents
log 'Preparing box package contents'
if [ -f conf/${DISTRIBUTION}-${RELEASE} ]; then
  cp conf/${DISTRIBUTION}-${RELEASE} ${WORKING_DIR}/lxc-config
else
  cp conf/${DISTRIBUTION} ${WORKING_DIR}/lxc-config
fi
cp conf/metadata.json ${WORKING_DIR}
sed -i "s/<TODAY>/${NOW}/" ${WORKING_DIR}/metadata.json

# Vagrant box!
log 'Packaging box'
TARBALL=$(readlink -f ${PACKAGE})
(cd ${WORKING_DIR} && tar -czf $TARBALL ./*)
