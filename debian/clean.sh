#!/bin/bash
set -e

echo "Cleaning up"

rm /envdump /script.sh

echo 'Removing temporary files...'
rm -rf /tmp/*

echo 'cleaning up dhcp leases'
rm -f /var/lib/dhcp/*

echo 'Removing downloaded packages...'
apt-get clean
