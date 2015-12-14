#!/bin/bash

source /etc/environment

HOMEDIR=$(eval echo "~`whoami`")

sudo docker run --rm \
    -v ${HOMEDIR}:/data/ behance/docker-aws-s3-downloader \
     us-east-1 $CONTROL_TIER_S3SECURE_BUCKET .hud

# it's expected that these fields are already in the form
# /KEY/NAMESPACE VALUE
while read line || [[ -n "$line" ]]; do
    etcdctl set $line
done < ${HOMEDIR}/.hud
