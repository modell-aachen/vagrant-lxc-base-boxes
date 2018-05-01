#!/bin/bash
set -e

source common/ui.sh
source common/utils.sh

# If container exists, check if want to continue
if $(lxc-ls | grep -q ${CONTAINER}); then
  if ! $(confirm "The '${CONTAINER}' container already exists, do you want to continue building the box?" 'y'); then
    log 'Aborting...'
    exit 1
  fi
fi

# If container exists and wants to continue building the box
if $(lxc-ls | grep -q ${CONTAINER}); then
  if $(confirm "Do you want to rebuild the '${CONTAINER}' container?" 'n'); then
    log "Destroying container ${CONTAINER}..."
    utils.lxc.stop
    utils.lxc.destroy
  else
    log "Reusing existing container..."
    exit 0
  fi
fi

# If we got to this point, we need to create the container
log "Creating container..."

  utils.lxc.create -t download -- \
                   --dist ${DISTRIBUTION} \
                   --release ${RELEASE} \
                   --arch ${ARCH}

if [ ${DISTRIBUTION} = 'fedora' ] ||\
   [ ${DISTRIBUTION} = 'ubuntu' ] ||\
   [ ${DISTRIBUTION} = 'debian' ]
then
  # Improve systemd support:
  # - The fedora template does it but the fedora images from the download
  #   template apparently don't.
  # - The debian template does it but the debian image from the download
  #   template apparently not.
  utils.lxc.stop
  echo  >> /var/lib/lxc/${CONTAINER}/config
  echo "# settings for systemd with PID 1:" >> /var/lib/lxc/${CONTAINER}/config
  echo "lxc.autodev = 1" >> /var/lib/lxc/${CONTAINER}/config
  utils.lxc.start
  utils.lxc.attach rm -f /dev/kmsg
  utils.lxc.stop
fi

log "Container created!"
