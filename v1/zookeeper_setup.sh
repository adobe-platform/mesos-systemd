#!/bin/bash

WORKING_DIR=/home/core/mesos-systemd/v1

# copy the zookeeper service
sudo cp $WORKING_DIR/zookeeper/zookeeper.service /etc/systemd/system

# copy the zookeeper configurations
sudo cp -r $WORKING_DIR/zookeeper/core/conf /core

# edit the Zookeeper ID
sudo vim /core/conf/myid

# edit the zookeeper config
sudo vim +29 /core/conf/zoo.cfg

# enable and start zookeeper
sudo systemctl enable zookeeper.service && sudo systemctl start zookeeper.service

echo "Done setting up Zookeeper"
