#!/bin/bash

source /etc/environment

if [ "${NODE_ROLE}" != "worker" ]; then
    exit 0
fi

etcdctl set /images/iam-proxy  	 "behance/iam-docker:latest"
docker pull $(etcdctl get /images/iam-proxy)

export NETWORK="bridge"
export GATEWAY="$(ifconfig docker0 | grep "inet " | awk -F: '{print $1}' | awk '{print $2}')"
export INTERFACE="docker0"

# These will not work until Docker > 1.9 is running
#export GATEWAY="$(docker network inspect "$NETWORK" | grep Gateway | cut -d '"' -f 4)"
#export INTERFACE="br-$(docker network inspect "$NETWORK" | grep Id | cut -d '"' -f 4 | head -c 12)"

sudo iptables -t nat -I PREROUTING -p tcp -d 169.254.169.254 --dport 80 -j DNAT --to-destination "$GATEWAY":8080 -i "$INTERFACE"

sudo fleetctl submit "${SCRIPTDIR}/v3/util-units/iam-proxy.service"
sudo fleetctl start "iam-proxy.service"

exit 0