#!/bin/bash

source /etc/environment

HOMEDIR=$(eval echo "~`whoami`")

sudo docker run --rm \
    -v ${HOMEDIR}:/data/ behance/docker-aws-s3-downloader \
     us-east-1 $CONTROL_TIER_S3SECURE_BUCKET .sumologic

SUMOLOGIC_ACCESS_ID=$(cat ${HOMEDIR}/.sumologic | grep ID | cut -d= -f2)
SUMOLOGIC_SECRET=$(cat ${HOMEDIR}/.sumologic | grep SECRET | cut -d= -f2)
etcdctl set /sumologic_id $SUMOLOGIC_ACCESS_ID
etcdctl set /sumologic_secret $SUMOLOGIC_SECRET
