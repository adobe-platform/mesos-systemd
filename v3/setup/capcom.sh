#!/bin/bash

source /etc/environment

# doing this for the time being because we're relying ENV vars in /etc/environment
if [ "${NODE_ROLE}" != "control" ]  && [ "${NODE_ROLE}" != "it-hybrid" ]; then
    exit 0
fi

if [ "$(etcdctl get capcom-bootstrapped)" == "true" ]; then
    exit 0
fi


etcdctl set capcom-bootstrapped true

etcdctl setdir CP
etcdctl set /CP/CP_APPLICATIONS '[]'
etcdctl set /CP/CP_HOST 127.0.0.1
etcdctl set /CP/CP_DB_PATH ./capcom.db
etcdctl set /CP/CP_KV_STORE_SERVER_ADDRESS  http://$CAPCOM_KV_ENDPOINT
etcdctl set /CP/CP_KV_TTL 10
etcdctl set /CP/CP_LOG_LEVEL "$CAPCOM_LOG_LEVEL"
etcdctl set /CP/CP_LOG_LOCATION "$CAPCOM_LOG_LOCATION"
etcdctl set /CP/CP_PORT 2002
etcdctl set /CP/CP_PROXY nginx
etcdctl set /CP/CP_PROXY_CONFIG_FILE /etc/nginx/nginx.conf
etcdctl set /CP/CP_PROXY_ENABLED true
etcdctl set /CP/CP_PROXY_RESTART_SCRIPT /restart_nginx_docker.sh
etcdctl set /CP/CP_PROXY_TIMEOUT 60000
etcdctl set /CP/CP_PROXY_DOCKER_COMMAND "nginx -g 'daemon off;'"

HOMEDIR=$(eval echo "~`whoami`")

AWS_CREDS=""
if [ ! -z $AWS_ACCESS_KEY ]; then
    AWS_CREDS=" -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY \
     -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY "
fi

sudo docker run --rm \
    -v ${HOMEDIR}:/data/ $AWS_CREDS behance/docker-aws-s3-downloader \
     us-east-1 $CONTROL_TIER_S3SECURE_BUCKET .capcom

# it's expected that these fields are already in the form
# /KEY/NAMESPACE VALUE

# To edit the fields in .flight-director:
# 1) Download the current version of .flight-director from S3: be-secure-<tier>/.flight-director
# 2) Edit this file locally
# 3) Verify changes with peers
# 4) Upload edited file back to S3: be-secure-tier/.flight-director
# 5) Restart flight-director fleet-units via jenkins for changes to take effect


printf "#!/bin/bash\nsource /etc/environment\n" >  ${HOMEDIR}/.capcom_runnable.sh
while read line || [[ -n "$line" ]]; do
    printf "etcdctl set $line \n" >> ${HOMEDIR}/.capcom_runnable.sh
done < ${HOMEDIR}/.capcom
chmod +x ${HOMEDIR}/.capcom_runnable.sh
${HOMEDIR}/.capcom_runnable.sh
rm ${HOMEDIR}/.capcom_runnable.sh
