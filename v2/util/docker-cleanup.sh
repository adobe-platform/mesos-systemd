#!/bin/bash

echo "==== Removing images"
# generate system images list
# Note: no etcdauth in mesos-systemd
for i in $(etcdctl ls images); do
    etcdctl get $i|sed -e 's/index.docker.io\///g'|sed -e 's/\:.*//g';
done > systemImages
# these two are from other unit files that do not use etcd /images
echo "aquasec/agent-data" >> systemImages
echo "behance/iam-docker" >> systemImages

# images that currently exist on host
docker images -a|grep -v -e 'REPOSITORY'|awk '{print $1}'|tr " " "\n" > existingImages

# list of images that exist on host, not in systemImages list
deletionCandidates=$(comm -23 <(sort existingImages) <(sort systemImages))

if [ -z "$deletionCandidates" ]; then
    echo "No images to delete."
else
    echo "Going to attempt to delete images:"
    docker images -a|egrep "$(echo $deletionCandidates| sed -e 's/ /\|/g')" > deleting
    cat deleting
    docker rmi $(cat deleting|awk '{print $3}')
    rm deleting systemImages existingImages
fi

echo "==== Removing dead containers & volumes"
docker rm -v $(docker ps -a -q) 2> /dev/null | xargs -n 1 -IXX echo "docker: Removing dead container XX"

echo "==== Removing remaining [orphaned] volumes"
docker volume rm $(docker volume ls -q) 2> /dev/null | xargs -n 1 -IXX echo "docker: Removing dead volume XX"

FSDRIVER=$(docker info|grep Storage|cut -d: -f2|tr -d [:space:])
echo "Driver $FSDRIVER"
echo "---- Complete ----"

sudo free -h
if [ "$FSDRIVER" = "devicemapper" ]; then
    sudo lvdisplay | grep Allocated | xargs -n 1 -IXX echo "docker lvm XX"
    docker info | grep Data | xargs -n 1 -IXX echo "docker XX"
else
    sudo df -Th
fi
