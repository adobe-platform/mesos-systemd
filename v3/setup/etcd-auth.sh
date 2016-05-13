!/bin/bash

source /etc/environment

etcdctl set /etcdctl/config/root-user root
etcdctl set /etcdctl/config/read-user read-user
etcdctl set /etcdctl/config/write-user write-user
