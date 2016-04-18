#!/bin/bash

source /etc/environment

HOMEDIR=$(eval echo "~`whoami`")

principalslave=$(etcdctl get /frameworkauth/username)
secretslave=$(etcdctl get /frameworkauth/secret)

mkdir $HOMEDIR/mesos-slave
touch $HOMEDIR/mesos-slave/passwd
sudo cp /root/.dockercfg /home/core/.dockercfg
sudo chown core:core /home/core/.dockercfg
chmod 0600 /home/core/mesos-slave/passwd


echo "$(eval echo $principalslave) $(eval echo $secretslave)" > $HOMEDIR/mesos-slave/passwd
