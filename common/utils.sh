#!/bin/bash

utils.lxc.attach() {
  cmd="$@"
  log "Running [${cmd}] inside '${CONTAINER}' container..."
  (lxc-attach -n ${CONTAINER} -- $cmd) &>> ${LOG}
}

utils.lxc.pipetofile() {
  log "Sending piped content inside '${CONTAINER}' at $1 ..."
  lxc-attach -n ${CONTAINER} -- /bin/bash -c "tee $1 > /dev/null" &>> ${LOG}
}

utils.lxc.runscript() {
  cat $1 | utils.lxc.pipetofile /script.sh
  utils.lxc.attach /bin/bash /script.sh
}

utils.lxc.start() {
  lxc-start -d -n ${CONTAINER} &>> ${LOG} || true
}

utils.lxc.stop() {
  lxc-stop -n ${CONTAINER} &>> ${LOG} || true
}

utils.lxc.destroy() {
  lxc-destroy -n ${CONTAINER} &>> ${LOG}
}

utils.lxc.create() {
  lxc-create -n ${CONTAINER} "$@" &>> ${LOG}
}
