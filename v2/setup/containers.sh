#!/bin/bash

source /etc/environment

# pull down images serially to avoid a FS layer clobbering bug in docker 1.6.x

docker pull behance/docker-gocron-logrotate
docker pull behance/docker-sumologic
docker pull behance/docker-dd-agent

if [ "${NODE_ROLE}" == "control" ]; then
    docker pull jenkins
    docker pull behance/docker-dd-agent-mesos
    docker pull mesosphere/mesos-master
    docker pull mesosphere/marathon
    docker pull mesosphere/chronos
    docker pull behance/exhibitor
    docker pull behance/flight-director # private repo, delete
fi

if [ "${NODE_ROLE}" == "worker" ]; then
    docker pull mesosphere/mesos-slave
fi

if [ "${NODE_ROLE}" == "proxy" ]; then
    docker pull behance/capcom # private repo, delete
fi
