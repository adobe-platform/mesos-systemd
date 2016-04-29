#!/bin/bash

source /etc/environment

if [ "${NODE_ROLE}" != "control" ]  && [ "${NODE_ROLE}" != "it-hybrid" ]; then
    exit 0
fi
if [ "$(etcdctl get /bootstrap.service/flight-director)" == "true" ]; then
    exit 0
fi

etcdctl set /bootstrap.service/flight-director true
etcdctl setdir flight-director
etcdctl set /flight-director/api-server-port 2001
etcdctl set /flight-director/chronos-master "$FLIGHT_DIRECTOR_CHRONOS_ENDPOINT"
etcdctl set /flight-director/db-name "$FLIGHT_DIRECTOR_DB_NAME"
etcdctl set /flight-director/db-engine mysql
etcdctl set /flight-director/db-path "$FLIGHT_DIRECTOR_DB_PATH"
etcdctl set /flight-director/db-username "$FLIGHT_DIRECTOR_DB_USERNAME"
etcdctl set /flight-director/dockercfg-location file:///root/.dockercfg
etcdctl set /flight-director/debug false
etcdctl set /flight-director/event-interface ''
etcdctl set /flight-director/event-port 2001
etcdctl set /flight-director/fixtures "$FLIGHT_DIRECTOR_FIXTURES"
etcdctl set /flight-director/kv-server http://localhost:2379
etcdctl set /flight-director/log-level "$FLIGHT_DIRECTOR_LOG_LEVEL"
etcdctl set /flight-director/log-location "$FLIGHT_DIRECTOR_LOG_LOCATION"
etcdctl set /flight-director/log-marathon-api-calls false
etcdctl set /flight-director/marathon-master "$FLIGHT_DIRECTOR_MARATHON_ENDPOINT"
etcdctl set /flight-director/mesos-master "$FLIGHT_DIRECTOR_MESOS_ENDPOINT"
etcdctl set /flight-director/marathon-master-protocol http
etcdctl set /flight-director/allow-marathon-unverified-tls false
etcdctl set /flight-director/mesos-master-protocol http
etcdctl set /flight-director/authorizer-type airlock
