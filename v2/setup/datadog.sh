#!/bin/bash

source /etc/environment

HOMEDIR=$(eval echo "~`whoami`")

sudo docker run --rm \
    -v ${HOMEDIR}:/data/ behance/docker-aws-s3-downloader \
     us-east-1 $CONTROL_TIER_S3SECURE_BUCKET .datadog

DATADOG_KEY=$(sudo cat ${HOMEDIR}/.datadog)

etcdctl set /ddapikey $DATADOG_KEY
