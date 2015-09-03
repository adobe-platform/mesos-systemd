#!/bin/bash

# pull down images serially to avoid a FS layer clobbering bug in docker 1.6.x

docker pull behance/docker-sumologic
docker pull behance/docker-dd-agent
docker pull behance/docker-dd-agent-mesos
docker pull jenkins
docker pull mesosphere/mesos-master
docker pull mesosphere/mesos-slave
docker pull mesosphere/marathon
docker pull mesosphere/chronos
