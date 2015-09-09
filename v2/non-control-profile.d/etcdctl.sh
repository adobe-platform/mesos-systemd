#!/bin/bash

source /etc/environment
export ETCDCTL_PEERS="http://$ETCDCTL_PEERS_ENDPOINT"
