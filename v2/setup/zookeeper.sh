#!/bin/bash

source /etc/environment

etcdctl set /zookeeper/s3_exhibitor_prefix "zk"
etcdctl set /zookeeper/s3_exhibitor_bucket $EXHIBITOR_S3BUCKET
