
#!/bin/bash

source /etc/environment

etcdctlrootusername=$(etcdctl get /etcdctlrootusername)
etcdctlrootpassword=$(etcdctl get /etcdctlrootpassword)
etcdctletcdreadusername=$(etcdctl get /etcdctletcdreadusername)
etcdctletcdreadpassword=$(etcdctl get /etcdctletcdreadpassword)
etcdctletcdreadwriteusername=$(etcdctl get /etcdctletcdreadwriteusername)
etcdctletcdreadwritepassword=$(etcdctl get /etcdctletcdreadwritepassword)





#add a root user

echo '{"username":"'$(eval echo $etcdctlrootusername)'", "password":"'$(eval echo $etcdctlrootpassword)'"}' > root.json
curl  -u  -L http://127.0.0.1:2379/v2/auth/users/$etcdctlrootusername -XPUT -d "@root.json"

#add a non root read only user
echo '{"username":"'$(eval echo $etcdctletcdreadusername)'", "password":"'$(eval echo $etcdctletcdreadpassword)'"}' > etcdreaduser.json
curl  -u  -L http://127.0.0.1:2379/v2/auth/users/$etcdctletcdusername -XPUT -d "@etcdreaduser.json"

#add a non root readwrite user
echo '{"username":"'$(eval echo $etcdctletcdreadwriteusername)'", "password":"'$(eval echo $etcdctletcdreadwritepassword)'"}' > etcdwriteuser.json
curl  -u  -L http://127.0.0.1:2379/v2/auth/users/$etcdctletcdusername -XPUT -d "@etcdwriteuser.json"


#Create a read only role:

etcdctl role add readonlyrolename


#Give read only access to this role:

etcdctl role grant readonlyrolename -path '/*' -read

#Create a readwrite only role:

etcdctl role add readwriterolename


#Give readwrite only access to this role:

etcdctl role grant readwriterolename -path '/*' -readwrite

#Give read only non root user read only role

echo '{"user": "'$(eval echo $etcdctletcdreadusername)'", "grant": ["readonlyrolename"]}' > readonlyrolename.json

curl  -L http://127.0.0.1:2379/v2/auth/users/$etcdctletcdreadusername -XPUT -d "@readonlyrolename.json"

#Give readwrite non root user readwrite role

echo '{"user": "'$(eval echo $etcdctletcdreadwriteusername)'", "grant": ["readonlyrolename"]}' > readwriterolename.json

curl  -L http://127.0.0.1:2379/v2/auth/users/$etcdctletcdreadwriteusername -XPUT -d "@readwriterolename.json"

#revoke guest role read:write access

etcdctl role revoke guest -path '/*' -readwrite

#enable authentication
curl  -L http://127.0.0.1:2379/v2/auth/enable -XPUT


