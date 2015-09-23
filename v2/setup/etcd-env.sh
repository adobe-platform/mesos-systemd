#!/bin/bash

ENV_FILE="/etc/environment"
ETCD_PREFIX="/environment"

while IFS='' read -r line || [[ -n "$line" ]]; do
    if [ "${line:0:1}" != "#" ]; then
      key=${line%=*}
      value=${line#*=}

      etcdkey="$ETCD_PREFIX/$key"
      etcdctl set $etcdkey $value
    fi
done < $ENV_FILE
