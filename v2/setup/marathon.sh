#!/bin/bash

source /etc/environment

HOMEDIR=$(eval echo "~`whoami`")

sudo docker run --rm \
    -v ${HOMEDIR}:/data/ behance/docker-aws-s3-downloader \
     us-east-1 $CONTROL_TIER_S3SECURE_BUCKET .marathon


etcdctl set /marathon_user $MARATHON_USER
etcdctl set /marathon_password $MARATHON_PASSWORD
