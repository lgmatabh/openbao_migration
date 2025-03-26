#!/bin/sh
set -x

echo "#### Step:  $0"

cp 98_vault_sysctl.conf /etc/sysctl.d/.
service systemd-sysctl restart
