#!/bin/bash

source /etc/environment

HOMEDIR=$(eval echo "~`whoami`")

principal=$(etcdctl get principal)
secret=$(etcdctl get secret)
principal1=$(etcdctl get principal1)
secret1=$(etcdctl get secret1)

mkdir $HOMEDIR/mesos-master
touch $HOMEDIR/mesos-master/passwd



echo "$(eval echo $principal) $(eval echo $secret)" > $HOMEDIR/mesos-master/passwd
echo "$(eval echo $principal1) $(eval echo $secret1)" >> $HOMEDIR/mesos-master/passwd
