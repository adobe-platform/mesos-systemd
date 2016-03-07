#!/bin/bash

source /etc/environment

HOMEDIR=$(eval echo "~`whoami`")

AWS_CREDS=""
if [ ! -z $AWS_ACCESS_KEY ]; then
    AWS_CREDS=" -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY \
     -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY "
fi

sudo docker run --rm \
    -v ${HOMEDIR}:/data/ $AWS_CREDS behance/docker-aws-s3-downloader \
     us-east-1 $CONTROL_TIER_S3SECURE_BUCKET .marathon


#etcdctl set /marathon/username $USER
#etcdctl set /marathon/password $PW

# it's expected that these fields are already in the form
# /KEY/NAMESPACE VALUE

# To edit the fields in .marathon:
# 1) Download the current version of .marathon from S3: be-secure-<tier>/.marathon
# 2) Edit this file locally
# 3) Verify changes with peers
# 4) Upload edited file back to S3: be-secure-tier/.marathon
# 5) Restart marathon fleet-units via jenkins for changes to take effect


while read line; do
    etcdctl set $line
done < ${HOMEDIR}/.marathon
