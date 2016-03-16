#!/bin/bash

source /etc/environment

Environment="principal=etcdctl get principal"
Environment="secret=etcdctl get secret"


sudo mkdir /home/core/mesos-slave
sudo touch /home/core/mesos-slave/passwd

echo "$($principal) $($secret)" >> /home/core/mesos-slave/passwd
