#!/bin/bash
set -e
source /etc/profile

echo "Cleaning up"

rm /script.sh

echo 'Removing temporary files...'
rm -rf /tmp/*

echo 'cleaning up distfiles'
rm -f /usr/portage/distfiles/*

