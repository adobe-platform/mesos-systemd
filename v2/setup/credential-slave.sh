#!/bin/bash

source /etc/environment

Environment="principal=etcdctl get principal"
Environment="secret=etcdctl get secret"


sudo mkdir /etc/mesos-slave
sudo touch /etc/mesos-slave/passwd

echo "$($principal) $($secret)" >> /etc/mesos-slave/passwd
