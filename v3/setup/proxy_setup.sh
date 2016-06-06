#!/bin/bash -x
source /etc/environment

if [ -f /etc/profile.d/etcdctl.sh ]; then 
      source /etc/profile.d/etcdctl.sh
fi

if [ "$NODE_ROLE" != "proxy" ]; then
    exit 0
fi

PROXY_SETUP_IMAGE=behance/mesos-proxy-setup:latest

docker run \
    --name mesos-proxy-setup \
    --log-opt max-size=`etcdctl get /docker/config/logs-max-size` \
    --log-opt max-file=`etcdctl get /docker/config/logs-max-file` \
    --net='host' \
    --privileged \
    ${PROXY_SETUP_IMAGE}
