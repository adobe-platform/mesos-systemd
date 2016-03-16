#!/bin/bash

source /etc/environment

Environment="principal=etcdctl get principal"
Environment="secret=etcdctl get secret"

sudo mkdir /home/core/mesos-master
sudo touch /home/core/mesos-master/passwd


echo "$($principal) $($secret)" >> /home/core/mesos-master/passwd
