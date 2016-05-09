
#!/bin/bash

source /etc/environment

etcdctlrootusername=$(etcdctl get /etcdctl/config/etcdctlrootusername)
etcdctlrootpassword=$(etcdctl get /etcdctl/config/etcdctlrootpassword)
etcdctletcdreadusername=$(etcdctl get /etcdctl/config/etcdctletcdreadusername)
etcdctletcdreadpassword=$(etcdctl get /etcdctl/config/etcdctletcdreadpassword)
etcdctletcdreadwriteusername=$(etcdctl get /etcdctl/config/etcdctletcdreadwriteusername)
etcdctletcdreadwritepassword=$(etcdctl get /etcdctl/config/etcdctletcdreadwritepassword)





#add a root user

echo '{"user":"'$(eval echo $etcdctlrootusername)'", "password":"'$(eval echo $etcdctlrootpassword)'"}' > /home/core/mesos-systemd/v2/util/root.json
curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $etcdctlrootusername) -XPUT -d "@root.json"

echo $(eval echo $etcdctlrootusername) > /home/core/.etcdrootuser
echo $(eval echo $etcdctlrootpassword) > /home/core/.etcdrootpassword

#add a non root read only user
echo '{"user":"'$(eval echo $etcdctletcdreadusername)'", "password":"'$(eval echo $etcdctletcdreadpassword)'"}' > /home/core/mesos-systemd/v2/util/etcdreaduser.json
curl   -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $etcdctletcdreadusername) -XPUT -d "@etcdreaduser.json"

#add a non root readwrite user
echo '{"user":"'$(eval echo $etcdctletcdreadwriteusername)'", "password":"'$(eval echo $etcdctletcdreadwritepassword)'"}' > /home/core/mesos-systemd/v2/util/etcdwriteuser.json
curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $etcdctletcdreadwriteusername) -XPUT -d "@etcdwriteuser.json"


#Create a read only role:

etcdctl role add readonlyrolename


#Give read only access to this role:

etcdctl role grant readonlyrolename -path '/*' -read

#Create a readwrite only role:

etcdctl role add readwriterolename


#Give readwrite only access to this role:

etcdctl role grant readwriterolename -path '/*' -readwrite

#Give read only non root user read only role

echo '{"user": "'$(eval echo $etcdctletcdreadusername)'", "grant": ["readonlyrolename"]}' > /home/core/mesos-systemd/v2/util/readonlyrolename.json

curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $etcdctletcdreadusername) -XPUT -d "@readonlyrolename.json"

#Give readwrite non root user readwrite role

echo '{"user": "'$(eval echo $etcdctletcdreadwriteusername)'", "grant": ["readwriterolename"]}' > /home/core/mesos-systemd/v2/util/readwriterolename.json

curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $etcdctletcdreadwriteusername) -XPUT -d "@readwriterolename.json"

#revoke guest role read:write access

#etcdctl role revoke guest -path '/*' -readwrite

#enable authentication
#curl  -L http://127.0.0.1:2379/v2/auth/enable -XPUT


#etcdctl auth enable
#curl -u $(/usr/bin/bash etcduser.sh):$(/usr/bin/bash etcdpassword.sh) -L http://127.0.0.1:2379/v2/auth/enable -XGET