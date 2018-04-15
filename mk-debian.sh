#!/bin/bash
set -e

source common/ui.sh
source common/utils.sh

export DISTRIBUTION=$1
export RELEASE=$2
export ARCH=$3
export CONTAINER=$4
export PACKAGE=$5
export ADDPACKAGES=${ADDPACKAGES-$(cat ${RELEASE}_packages | tr "\n" " ")}
export ROOTFS="${HOME}/.local/share/lxc/${CONTAINER}/rootfs"
export WORKING_DIR="/tmp/${CONTAINER}"
export NOW=$(date -u)
export LOG=$(readlink -f .)/log/${CONTAINER}.log

mkdir -p $(dirname $LOG)
echo '############################################' > ${LOG}
echo "# Beginning build at $(date)" >> ${LOG}
touch ${LOG}
chmod +rw ${LOG}

if [ -f ${PACKAGE} ]; then
  warn "The box '${PACKAGE}' already exists, skipping..."
  echo
  exit
fi

debug "Creating ${WORKING_DIR}"
mkdir -p ${WORKING_DIR}

info "Building box to '${PACKAGE}'..."

./common/download.sh ${DISTRIBUTION} ${RELEASE} ${ARCH} ${CONTAINER}
utils.lxc.start

SECS=15
log "Sleeping for $SECS seconds..."
sleep $SECS

utils.lxc.runscript debian/vagrant-lxc-fixes.sh
utils.lxc.runscript debian/install-extras.sh
utils.lxc.runscript common/prepare-vagrant-user.sh
utils.lxc.runscript debian/clean.sh
utils.lxc.stop

./common/package.sh

info "Finished building '${PACKAGE}'!"
log "Run \`lxc-destroy -n ${CONTAINER}\` or \`make clean\` to remove the container that was created along the way"
echo
