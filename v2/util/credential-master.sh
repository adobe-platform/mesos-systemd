#!/bin/bash

source /etc/environment

principal=$(etcdctl get principal)
secret=$(etcdctl get secret)

sudo mkdir /home/core/mesos-master
sudo touch /home/core/mesos-master/passwd



echo "'$(eval echo $principal)' '$(eval echo $secret)'" > /home/core/mesos-master/passwd
