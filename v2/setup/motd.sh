#!/bin/bash

source /etc/environment

sudo echo -e "Mesos Cluster\nTier: ${NODE_TIER}\nProduct: ${NODE_PRODUCT}" > /etc/motd.d/node-info.conf
