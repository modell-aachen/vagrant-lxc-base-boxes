#!/bin/bash
set -e
source /etc/profile

echo "Cleaning up"

rm /script.sh

echo 'Removing temporary files...'
rm -rf /tmp/*

echo 'cleaning up dhcp leases'
rm -f /var/lib/dhcp/*

echo 'Removing downloaded packages...'
apt-get clean
