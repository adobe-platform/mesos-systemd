#!/bin/bash

source /etc/environment

TABLE=`sudo echo $SECRETS_TABLE`
docker pull behance/docker-aws-secrets-downloader:latest

# Get all available secrets and configs
AV_SECRETS=`sudo docker run behance/docker-aws-secrets-downloader --table $TABLE --key secrets`
AV_CONFIGS=`sudo docker run behance/docker-aws-secrets-downloader --table $TABLE --key configs`

echo "$AV_SECRETS" | while read line ; do
	SECRET=`sudo docker run behance/docker-aws-secrets-downloader --table $TABLE --key secrets --name $line`
	SECRET_TYPE=`echo $SECRET | awk -F " " '{print $2}'`
	SECRET_PATH=`echo $SECRET | awk -F " " '{print $3}'`
	SECRET_VAL=`echo $SECRET | awk -F " " '{print $4}'`

	if [[ "$SECRET_TYPE" = "etcd" ]]; then
		echo "Setting ETCD value for secret: $SECRET_PATH"
		etcdctl set $SECRET_PATH $SECRET_VAL &>/dev/null
	fi
done

echo "$AV_CONFIGS" | while read line ; do
	CONFIG=`docker run behance/docker-aws-secrets-downloader --table $TABLE --key configs --name $line`
	CONFIG_PATH=`echo $CONFIG | awk -F " " '{print $1}'`
	CONFIG_VAL=`echo $CONFIG | awk -F " " '{print $2}'`

	echo "Setting ETCD value for config: $CONFIG_PATH"
	etcdctl set $CONFIG_PATH $CONFIG_VAL &>/dev/null
done

exit 0