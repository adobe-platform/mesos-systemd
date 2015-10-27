#!/bin/bash

source /etc/environment

HOMEDIR=$(eval echo "~`whoami`")

sudo docker run --rm \
    -v ${HOMEDIR}:/data/ behance/docker-aws-s3-downloader \
     us-east-1 $CONTROL_TIER_S3SECURE_BUCKET .marathon

SYSDIG_KEY=$(sudo cat ${HOMEDIR}/.marathon)

etcdctl set /marathon_user $marathon_user
etcdctl set /marathon_password $MARATHON_PASSWORD
