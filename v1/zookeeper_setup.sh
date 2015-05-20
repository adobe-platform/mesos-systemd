#!/bin/bash

# copy the zookeeper service
sudo cp ./zookeeper/zookeeper.service /etc/systemd/system

# copy the zookeeper configurations
sudo cp -r ./zookeeper/root/conf /root

# edit the Zookeeper ID
sudo vim /root/conf/myid

# edit the zookeeper config
sudo vim +29 /root/conf/zoo.cfg

# enable and start zookeeper
sudo systemctl enable zookeeper.service && sudo systemctl start zookeeper.service

echo "Done setting up Zookeeper"
