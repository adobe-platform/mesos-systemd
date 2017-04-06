#!/bin/bash

source /etc/environment

if [ "${NODE_ROLE}" != "proxy" ]; then
    exit 0
fi

export ETCDCTL_PEERS="http://$ETCDCTL_PEERS_ENDPOINT"

if [ "$(etcdctl get images-proxy-bootstrapped)" == "true" ]; then
    echo "proxy-tier images already bootstrapped, skipping"
    exit 0
fi
etcdctl set images-proxy-bootstrapped true

etcdctl set /images/capcom       "behance/capcom:8fa735d310d0a46fc3acc34245c8bf63e8447ef4"
etcdctl set /images/proxy        "nginx:1.9.5"

# pull down images serially to avoid a FS layer clobbering bug in docker 1.6.x
docker pull behance/mesos-proxy-setup
docker pull $(etcdctl get /images/capcom)
docker pull $(etcdctl get /images/proxy)
