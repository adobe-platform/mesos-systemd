
#!/bin/bash

source /etc/environment

#Disable authentication

#curl  -L http://127.0.0.1:2379/v2/auth/enable -XDELETE

ROOT_USERNAME=$(etcdctl get /etcdctl/config/root-user)
ROOT_PASSWORD=$(etcdctl get /etcdctl/config/root-password)
READ_USERNAME=$(etcdctl get /etcdctl/config/read-user)
READ_PASSWORD=$(etcdctl get /etcdctl/config/read-password)
WRITE_USERNAME=$(etcdctl get /etcdctl/config/write-user)
WRITE_PASSWORD=$(etcdctl get /etcdctl/config/write-password)

#add a root user

echo '{"user":"'$(eval echo $ROOT_USERNAME)'", "password":"'$(eval echo $ROOT_PASSWORD)'"}' > /opt/etcdctl/root-user.json
curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $ROOT_USERNAME) -XPUT -d "@/opt/etcdctl/root-user.json"


#add a non root read only user
echo '{"user":"'$(eval echo $READ_USERNAME)'", "password":"'$(eval echo $READ_PASSWORD)'"}' > /opt/etcdctl/read-user.json
curl   -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $READ_USERNAME) -XPUT -d "@/opt/etcdctl/read-user.json"

#add a non root readwrite user
echo '{"user":"'$(eval echo $WRITE_USERNAME)'", "password":"'$(eval echo $WRITE_PASSWORD)'"}' > /opt/etcdctl/write-user.json
curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $WRITE_USERNAME) -XPUT -d "@//opt/etcdctl/write-user.json"

#Create a read only role:

etcdctl role add readonlyrole

#Give read only access to this role:

etcdctl role grant readonlyrole -path '/*' -read

#Create a readwrite only role:

etcdctl role add readwriterole

#Give readwrite only access to this role:

etcdctl role grant readwriterole -path '/*' -readwrite

#Give read only non root user read only role

echo '{"user": "'$(eval echo $READ_USERNAME)'", "grant": ["readonlyrole"]}' > /opt/etcdctl/readonlyrole.json

curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $READ_USERNAME) -XPUT -d "@/opt/etcdctl/readonlyrole.json"

#Give readwrite non root user readwrite role

echo '{"user": "'$(eval echo $WRITE_USERNAME)'", "grant": ["readwriterole"]}' > /opt/etcdctl/readwriterole.json

curl  -L http://127.0.0.1:2379/v2/auth/users/$(eval echo $WRITE_USERNAME) -XPUT -d "@/opt/etcdctl/readwriterole.json"

#revoke guest role read:write access

#etcdctl role revoke guest -path '/*' -readwrite

#Enable authentication

curl  -L http://127.0.0.1:2379/v2/auth/enable -XPUT

#etcdctl auth enable

#Get authentication Status
#curl -u $(echo "$(cat root.json |jq '.user')" | sed -e 's/^"//'  -e 's/"$//'):$(echo "$(cat root.json |jq '.password')" | sed -e 's/^"//'  -e 's/"$//') -L http://127.0.0.1:2379/v2/auth/users -XGET

sudo chmod 0600 /opt/etcdctl/*
sudo chown -R $(whoami):$(whoami) /opt/etcdctl

