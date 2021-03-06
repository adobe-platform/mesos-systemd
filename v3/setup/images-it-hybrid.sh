#!/bin/bash -x

source /etc/environment

if [ "${NODE_ROLE}" != "it-hybrid" ]; then
    exit 0
fi

if [ "$(etcdctl get /bootstrap.service/images-it-hybrid-bootstrapped)" == "true" ]; then
    echo "it-hybrid-tier images already bootstrapped, skipping"
    exit 0
fi
etcdctl set /bootstrap.service/images-it-hybrid-bootstrapped true

etcdctl set /images/flight-director "index.docker.io/behance/flight-director:latest"
etcdctl set /images/capcom       	"index.docker.io/behance/capcom:latest"


docker pull $(etcdctl get /images/flight-director)
docker pull $(etcdctl get /images/capcom)
