#!/bin/bash

source /etc/environment
export ETCDCTL_PEERS="http://$ETCDCTL_PEERS_ENDPOINT"

etcdctl set /images/capcom       "behance/capcom:latest"
etcdctl set /images/capcom2      "behance/capcom:latest"
etcdctl set /images/chronos      "mesosphere/chronos:chronos-2.4.0-0.1.20150828104228.ubuntu1404-mesos-0.23.0-1.0.ubuntu1404"
etcdctl set /images/fd           "behance/flight-director:latest"
etcdctl set /images/marathon     "mesosphere/marathon:v0.10.0"
etcdctl set /images/mesos-master "mesosphere/mesos-master:0.22.1-1.0.ubuntu1404"
etcdctl set /images/mesos-slave  "mesosphere/mesos-slave:0.22.1-1.0.ubuntu1404"
etcdctl set /images/zk-exhibitor "mbabineau/zookeeper-exhibitor:latest"
