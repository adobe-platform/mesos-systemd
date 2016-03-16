#!/bin/bash

source /etc/environment

principal=$(etcdctl get principal)
secret=$(etcdctl get secret)


sudo mkdir /home/core/mesos-slave
sudo touch /home/core/mesos-slave/passwd

echo "'$(eval echo $principal)' '$(eval echo $secret)'" > /home/core/mesos-slave/passwd
