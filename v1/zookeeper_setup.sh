#!/bin/bash

WORKING_DIR=/home/core/mesos-systemd/v1

# copy the zookeeper service
sudo cp $WORKING_DIR/zookeeper/zookeeper.service /etc/systemd/system

# copy the zookeeper configurations
sudo cp -r $WORKING_DIR/zookeeper/core/conf /home/core

# edit the Zookeeper ID
sudo vim /home/core/conf/myid

# edit the zookeeper config
sudo vim +29 /home/core/conf/zoo.cfg

# enable and start zookeeper
echo "Enabling Zookeeper. This might take a few minutes to download the Docker image"
sudo systemctl enable zookeeper.service && sudo systemctl start zookeeper.service

echo "Done setting up Zookeeper"
