#!/bin/bash

source /etc/environment

HOMEDIR=$(eval echo "~`whoami`")

principal=$(etcdctl get principal)
secret=$(etcdctl get secret)

mkdir $HOMEDIR/mesos-slave
touch $HOMEDIR/mesos-slave/passwd



echo "$(eval echo $principal) $(eval echo $secret)" > $HOMEDIR/mesos-slave/passwd

