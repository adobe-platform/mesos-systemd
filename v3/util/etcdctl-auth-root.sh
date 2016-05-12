
#!/bin/bash

source /etc/environment

#Disable authentication

#curl  -L http://127.0.0.1:2379/v2/auth/enable -XDELETE

etcdctlrootusername=$(etcdctl get /etcdctl/config/etcdctl-root-user)
etcdctlrootpassword=$(etcdctl get /etcdctl/config/etcdctl-root-password)
etcdctletcdreadusername=$(etcdctl get /etcdctl/config/etcdctl-read-user)
etcdctletcdreadpassword=$(etcdctl get /etcdctl/config/etcdctl-read-password)
etcdctletcdreadwriteusername=$(etcdctl get /etcdctl/config/etcdctl-read-write-user)
etcdctletcdreadwritepassword=$(etcdctl get /etcdctl/config/etcdctl-read-write-password)

#add a root user

echo '{"user":"'$(eval echo $etcdctlrootusername)'", "password":"'$(eval echo $etcdctlrootpassword)'"}' > /home/core/mesos-systemd/v3/util/root.json
curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $etcdctlrootusername) -XPUT -d "@/home/core/mesos-systemd/v3/util/root.json"


#add a non root read only user
echo '{"user":"'$(eval echo $etcdctletcdreadusername)'", "password":"'$(eval echo $etcdctletcdreadpassword)'"}' > /home/core/mesos-systemd/v3/util/etcdreaduser.json
curl   -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $etcdctletcdreadusername) -XPUT -d "@/home/core/mesos-systemd/v3/util/etcdreaduser.json"

#add a non root readwrite user
echo '{"user":"'$(eval echo $etcdctletcdreadwriteusername)'", "password":"'$(eval echo $etcdctletcdreadwritepassword)'"}' > /home/core/mesos-systemd/v3/util/etcdwriteuser.json
curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $etcdctletcdreadwriteusername) -XPUT -d "@/home/core/mesos-systemd/v3/util/etcdwriteuser.json"

#Create a read only role:

etcdctl role add readonlyrolename

#Give read only access to this role:

etcdctl role grant readonlyrolename -path '/*' -read

#Create a readwrite only role:

etcdctl role add readwriterolename

#Give readwrite only access to this role:

etcdctl role grant readwriterolename -path '/*' -readwrite

#Give read only non root user read only role

echo '{"user": "'$(eval echo $etcdctletcdreadusername)'", "grant": ["readonlyrolename"]}' > /home/core/mesos-systemd/v3/util/readonlyrolename.json

curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $etcdctletcdreadusername) -XPUT -d "@/home/core/mesos-systemd/v3/util/readonlyrolename.json"

#Give readwrite non root user readwrite role

echo '{"user": "'$(eval echo $etcdctletcdreadwriteusername)'", "grant": ["readwriterolename"]}' > /home/core/mesos-systemd/v3/util/readwriterolename.json

curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $etcdctletcdreadwriteusername) -XPUT -d "@/home/core/mesos-systemd/v3/util/readwriterolename.json"

#revoke guest role read:write access

#etcdctl role revoke guest -path '/*' -readwrite

#Enable authentication

curl  -L http://127.0.0.1:2379/v2/auth/enable -XPUT

#etcdctl auth enable

#Get authentication Status
#curl -u $(echo "$(cat root.json |jq '.user')" | sed -e 's/^"//'  -e 's/"$//'):$(echo "$(cat root.json |jq '.password')" | sed -e 's/^"//'  -e 's/"$//') -L http://127.0.0.1:2379/v2/auth/users -XGET

