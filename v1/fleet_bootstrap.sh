#!/bin/bash

# this script exists to bootstrap our Mesos cluster.
# this will:
#   > update all of the service definitions with the location of the address for Zookeeper
#   > start all of the services:
#   > all nodes:
#     > docker-cleanup.service
#     > docker-cleanup.timer
#   > master nodes:
#     > mesos-master
#     > marathon
#     > chronos
#   > worker nodes:
#     > mesos-slave

# cd to the correct directoy
cd ./fleet_units

# if .zookeeper exists, use its value
if [[ -f /home/core/.zookeeper ]]
then
  echo "Reading zookeeper value from /home/core/.zookeeper"
  ZOOKEEPER=$(cat /home/core/.zookeeper)
else
  # get the zookeeper address
  echo -e "\nZookeeper Configuration:"
  echo "Our default is to list the private DNS name of the ELB for our masters. Ex 'internal-coreos-control-etcd-852307729.us-west-2.elb.amazonaws.com:2181'"
  echo "You can also supply a comma separated list of ip:port. Ex. '10.43.1.22:2181,10.43.3.128:2181,10.43.2.193:2181'"
  read -p "Enter Zookeeper value: " ZOOKEEPER
fi
# update the scripts with zookeeper value
sed -i "s/<ZK_ELB>/$ZOOKEEPER/g" *.service

# start each of the services
SERVICES="
docker-cleanup.service
docker-cleanup.timer
chronos.service
marathon.service
mesos-master.service
mesos-slave.service
"

for SERVICE in $SERVICES
do
  echo "Starting $SERVICE"
  fleetctl start $SERVICE
done

cd -
