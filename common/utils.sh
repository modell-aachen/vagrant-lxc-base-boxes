#!/bin/bash

utils.lxc.attach() {
  cmd="$@"
  log "Running [${cmd}] inside '${CONTAINER}' container..."
  lxc-attach -n ${CONTAINER} -- $cmd
}

utils.lxc.pipetofile() {
  lxc-attach -n ${CONTAINER} -- /bin/bash -c "tee $1 > /dev/null"
}

utils.lxc.runscript() {
  log "Running $1 inside '${CONTAINER}'..."
  cat $1 | utils.lxc.pipetofile /script.sh
  utils.lxc.attach /bin/bash /script.sh
}

utils.lxc.start() {
  lxc-start -d -n ${CONTAINER} || true
}

utils.lxc.stop() {
  lxc-stop -n ${CONTAINER} || true
}

utils.lxc.destroy() {
  lxc-destroy -n ${CONTAINER}
}

utils.lxc.create() {
  lxc-create -n ${CONTAINER} "$@"
}
