#!/bin/bash -x

# NOTE: this needs to be run with sudo privileges
# $1 must be the SCRIPTDIR


# Can be set via /etc/environment
if [ -z "${ETCD_LOGGER}" ];then
   ETCD_LOGGER="--log-opt max-size=10m --log-opt max-file=10"
fi

mkdir -p /etc/sysconfig
CFGFILE=/etc/sysconfig/etcd

# Write the preferred logger to a place the service can get the setting
if [ ! -f $CFGFILE ]; then
    echo "ETCD_LOGGER=${ETCD_LOGGER}" > $CFGFILE
    chown root:root $CFGFILE
    chmod 0644 $CFGFILE
fi

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

# Sometimes this is needed?
systemctl daemon-reload

SCRIPTDIR=$1
cp "${SCRIPTDIR}/v3/util-units/etcd-peers.service" /etc/systemd/system/
systemctl start etcd-peers

echo "-------Waiting for etcd2 to start-------"
while etcdctl cluster-health|grep unhealthy
do
  sleep 8
done

echo "-------etcd2 started, continuing with bootstrapping-------"
