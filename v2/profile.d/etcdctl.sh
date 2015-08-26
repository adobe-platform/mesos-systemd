#!/bin/bash

source /etc/environment
export ETCDCTL_PEERS="http://$CAPCOM_KV_ENDPOINT"
