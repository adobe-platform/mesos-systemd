#!/bin/bash

source /etc/environment

# pull down images serially to avoid a FS layer clobbering bug in docker 1.6.x

docker pull behance/docker-sumologic
docker pull behance/docker-dd-agent
docker pull behance/docker-dd-agent-mesos

if [ "${NODE_ROLE}" == "control" ]; then
    docker pull jenkins
    docker pull mesosphere/mesos-master
    docker pull mesosphere/marathon
    docker pull mesosphere/chronos
fi

if [ "${NODE_ROLE}" == "worker" ]; then
    docker pull mesosphere/mesos-slave
fi
