#!/bin/bash

source /etc/environment

if [ "${NODE_ROLE}" != "worker" ]; then
    exit 0
fi

export ETCDCTL_PEERS="http://$ETCDCTL_PEERS_ENDPOINT"

if [ "$(etcdctl get images-worker-bootstrapped)" == "true" ]; then
    echo "worker-tier images already bootstrapped, skipping"
    exit 0
fi
etcdctl set images-worker-bootstrapped true

etcdctl set /images/mesos-slave  "mesosphere/mesos-slave:0.22.1-1.0.ubuntu1404"

# pull down images serially to avoid a FS layer clobbering bug in docker 1.6.x
docker pull $(etcdctl get /images/mesos-slave)
