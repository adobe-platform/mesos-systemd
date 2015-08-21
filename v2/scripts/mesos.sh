#!/bin/bash

# TODO: super broken

UTIL_IMAGE=behance/utility:latest
S3_SECURE_BUCKET=", Ref(s3_secure_bucket),"
S3_EXHIBITOR_BUCKET=", Ref(s3_exhibitor_bucket),"
docker pull $UTIL_IMAGE; 
sudo docker run -v /root:/root $UTIL_IMAGE /bin/sh -c \"aws s3 cp s3://$S3_SECURE_BUCKET/.datadog /root/.datadog\"; 
sudo docker run -v /root:/root $UTIL_IMAGE /bin/sh -c \"aws s3 cp s3://$S3_SECURE_BUCKET/.sumologic /root/.sumologic\"; 
sudo docker run -v /root:/root $UTIL_IMAGE /bin/sh -c \"aws s3 cp s3://$S3_SECURE_BUCKET/.bbuild-github-token /root/.bbuild-github-token\"; 
sudo cp /root/.datadog /home/core/.datadog;
sudo cp /root/.sumologic /home/core/.sumologic;
sudo cp /root/.bbuild-github-token /home/core/.bbuild-github-token;
DATADOG_KEY=$(cat /home/core/.datadog)
SUMOLOGIC_ACCESS_ID=$(cat /home/core/.sumologic | grep ID | cut -d= -f2)
SUMOLOGIC_SECRET=$(cat /home/core/.sumologic | grep SECRET | cut -d= -f2)
GITHUB_TOKEN=$(cat /home/core/.bbuild-github-token)
#read -p 'Enter datadog api key for this account: ' DATADOG_KEY 
#read -p 'Enter Sumologic Access ID for this account: ' SUMOLOGIC_ACCESS_ID 
#read -p 'Enter Sumologic Secret for this account: ' SUMOLOGIC_SECRET 
mkdir /home/core/install 
docker pull behance/mesos-install:latest 
docker run \\
   --rm \\
   --net=host \\
   -v /root:/root \\
   -v /home/core:/core \\
   -v /usr/bin/fleetctl:/install/fleetctl \\
   -v /usr/bin/etcdctl:/install/etcdctl \\
   -v /var/run/fleet.sock:/var/run/fleet.sock \\
   -e DATADOG_KEY=$DATADOG_KEY \\
   -e S3_EXHIBITOR_BUCKET=$S3_EXHIBITOR_BUCKET \\
   -e SUMOLOGIC_ACCESS_ID=$SUMOLOGIC_ACCESS_ID \\
   -e SUMOLOGIC_SECRET=$SUMOLOGIC_SECRET \\
   -e GITHUB_TOKEN=$GITHUB_TOKEN \\
   behance/mesos-install:latest 

