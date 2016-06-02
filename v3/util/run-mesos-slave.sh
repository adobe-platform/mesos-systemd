#!/bin/bash -ex

set -x
# Run as user core
id
source /etc/environment

source /etc/profile.d/etcdctl.sh 

IMAGE=`etcdctl get /images/mesos-slave`
ZK_USERNAME=`etcdctl get /zookeeper/config/username`
ZK_PASSWORD=`etcdctl get /zookeeper/config/password`
ZK_ENDPOINT=`etcdctl get /zookeeper/config/endpoint`
LOGMX=`etcdctl get /docker/config/logs-max-file`
LOGFILE=`etcdctl get /docker/config/logs-max-file`

docker pull $IMAGE

if [ $? -ne 0 ] ;then 
    echo "Pull of $IMAGE failed" >&2
fi
 
docker ps | grep -q mesos-slave
if [ $? -eq 0 ];then
    # aka ExecStartPre
   /usr/bin/docker kill mesos-slave
fi
#
docker ps -a | grep mesos-slave | grep -q Exit
if [ $? -eq 0 ];then
    # aka ExecStartPre
    /usr/bin/docker rm mesos-slave
fi

sudo -E docker run \
    --name=mesos-slave \
    --net=host \
    --pid=host \
    --privileged \
    --log-opt max-size=$LOGMX \
    --log-opt max-file=$LOGFILE\
    -p 5051:5051 \
    -v /home/core/.dockercfg:/root/.dockercfg:ro \
    -v /sys:/sys \
    -v /usr/bin/docker:/usr/bin/docker:ro \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /lib64/libdevmapper.so:/lib/libdevmapper.so.1.02:ro \
    -v /lib64/libsystemd.so:/lib/libsystemd.so.0:ro \
    -v /lib64/libgcrypt.so:/lib/libgcrypt.so.20:ro \
    -v /var/lib/mesos/slave:/var/lib/mesos/slave \
    -v /opt/mesos/credentials:/opt/mesos/credentials:ro \
    $IMAGE \
    --ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4) \
    --attributes=zone:$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)\;os:coreos\;worker_group:$WORKER_GROUP \
    --containerizers=docker,mesos \
    --executor_registration_timeout=10mins \
    --hostname=$(curl -s http://169.254.169.254/latest/meta-data/local-hostname) \
    --log_dir=/var/log/mesos \
    --credential=/opt/mesos/credentials \
    --master=zk://$ZK_USERNAME:$ZK_PASSWORD@$ZK_ENDPOINT/mesos \
    --work_dir=/var/lib/mesos/slave \
    --cgroups_enable_cfs
