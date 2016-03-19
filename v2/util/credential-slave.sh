#!/bin/bash

source /etc/environment

HOMEDIR=$(eval echo "~`whoami`")

principal-slave=$(etcdctl get principal-slave)
secret-slave=$(etcdctl get secret-slave)

mkdir $HOMEDIR/mesos-slave
touch $HOMEDIR/mesos-slave/passwd



echo "$(eval echo $principal-slave) $(eval echo $secret-slave)" > $HOMEDIR/mesos-slave/passwd
