#!/bin/bash

source /etc/environment

if [ -z $MESOS_SLAVE_IMAGE ]; then
    MESOS_SLAVE_IMAGE=mesosphere/mesos-slave:0.22.1-1.0.ubuntu1404
    echo "MESOS_SLAVE_IMAGE=${MESOS_SLAVE_IMAGE}" >> /etc/environment
fi
docker pull ${MESOS_SLAVE_IMAGE}

if [ -z $MESOS_MASTER_IMAGE ]; then
    MESOS_MASTER_IMAGE=mesosphere/mesos-master:0.22.1-1.0.ubuntu1404
    echo "MESOS_MASTER_IMAGE=${MESOS_MASTER_IMAGE}" >> /etc/environment
fi
docker pull ${MESOS_MASTER_IMAGE}

if [ -z $CHRONOS_IMAGE ]; then
    CHRONOS_IMAGE=mesosphere/chronos:chronos-2.3.4-1.0.81.ubuntu1404-mesos-0.22.1-1.0.ubuntu1404
    echo "CHRONOS_IMAGE=${CHRONOS_IMAGE}" >> /etc/environment
fi
docker pull ${CHRONOS_IMAGE}

if [ -z $MARATHON_IMAGE ]; then
    MARATHON_IMAGE=mesosphere/marathon:v0.10.0
    echo "MARATHON_IMAGE=${MARATHON_IMAGE}" >> /etc/environment
fi
docker pull ${MARATHON_IMAGE}
