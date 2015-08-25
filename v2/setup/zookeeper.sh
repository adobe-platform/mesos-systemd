#!/bin/bash

source /etc/environment

if [ "${NODE_ROLE}" != "control" ]; then
    exit 0
fi

etcdctl set /zookeeper/s3_exhibitor_prefix "zk"
etcdctl set /zookeeper/s3_exhibitor_bucket $EXHIBITOR_S3BUCKET
