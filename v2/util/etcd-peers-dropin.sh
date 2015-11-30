#!/bin/bash

# NOTE: this needs to be run with sudo privileges

echo "-------Control node found, setting up etcd peers-------"

mkdir -p /etc/systemd/system/etcd2.service.d
DROPIN_FILE=/etc/systemd/system/etcd2.service.d/30-etcd_peers.conf

cat > $DROPIN_FILE <<EOF
[Service]
# Load the other hosts in the etcd leader autoscaling group from file
EnvironmentFile=/etc/sysconfig/etcd-peers
EOF

chown root:root $DROPIN_FILE
chmod 0644 $DROPIN_FILE

cp "${SCRIPTDIR}/v2/util-units/etcd-peers.service" /etc/systemd/system/
systemctl start etcd-peers
