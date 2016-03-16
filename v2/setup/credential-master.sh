#!/bin/bash

source /etc/environment

Environment="principal=etcdctl get principal"
Environment="secret=etcdctl get secret"

sudo mkdir /etc/mesos-master
sudo touch /etc/mesos-master/passwd


echo "$($principal) $($secret)" >> /etc/mesos-master/passwd
