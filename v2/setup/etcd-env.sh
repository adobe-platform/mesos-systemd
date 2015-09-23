#!/bin/bash

ENV_FILE="/etc/environment"
ETCD_PREFIX="/environment"
IGNORED='^NODE|^COREOS|^#|^FLIGHT_DIRECTOR|^CAPCOM'

for line in $(cat $ENV_FILE|egrep -v $IGNORED); do
    if [ "${line:0:1}" == "#" ]; then
      continue
    fi

    key=${line%=*}
    value=${line#*=}

    etcdkey="$ETCD_PREFIX/$key"
    etcdctl set $etcdkey $value
done
