#!/usr/bin/bash -xe

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOMEDIR=$(eval echo "~`whoami`")
OWNER=$(whoami)

source /etc/environment

# On the worker tier, the containers need to be launched with a role
# because of the IAM proxy metadata service.
IAM_ROLE_LABEL=""

if [[ "${NODE_ROLE}" = "worker" && ! -z "$CONTAINERS_ROLE" ]]; then
    IAM_ROLE_LABEL=' --label com.swipely.iam-docker.iam-profile='"$CONTAINERS_ROLE"' '

    # Wait until the iam-proxy service becomes available
    while true; do
    	echo "Waiting for iam-proxy fleet unit to start..."
    	OUTPUT=`fleetctl list-units | grep iam-proxy.service | grep running`
    	if [[ ! -z "$OUTPUT" ]]; then
    		echo "iam-proxy fleet unit running"
    		break
    	fi
    	echo "iam-proxy fleet unit not yet running..."
    	sleep 5
    done
fi

TABLE=`sudo echo $SECRETS_TABLE`
docker pull behance/docker-aws-secrets-downloader:latest

# Create a dockercfg
DOCKERCFG_CONTENTS=`sudo docker run $IAM_ROLE_LABEL behance/docker-aws-secrets-downloader --table $TABLE --key secrets --name DOCKERCFG --format plain`
echo "$DOCKERCFG_CONTENTS" > /home/${OWNER}/.dockercfg
sudo chown -R ${OWNER}:${OWNER} /home/${OWNER}/.dockercfg
sudo cp /home/${OWNER}/.dockercfg /root/.dockercfg

# ensure that we have a public key for our RSA key and that it's authorized
if [ -f ${HOMEDIR}/.ssh/id_rsa ]; then
    ssh-keygen -f ${HOMEDIR}/.ssh/id_rsa -y > ${HOMEDIR}/.ssh/id_rsa.pub
    cat ${HOMEDIR}/.ssh/id_rsa.pub >> ${HOMEDIR}/.ssh/authorized_keys
fi

AV_SECRETS=`sudo docker run $IAM_ROLE_LABEL behance/docker-aws-secrets-downloader --table $TABLE --key secrets`

# Save the RDS password to environment variable in control tier
# TODO: :(
if [[ "$NODE_ROLE" = "control" && $AV_SECRETS == *"RDSPASSWORD"* ]]; then
    RDSPASSWORD=`sudo docker run $IAM_ROLE_LABEL behance/docker-aws-secrets-downloader --table $TABLE --key secrets --name RDSPASSWORD --format plain`
    etcdctl set /environment/RDSPASSWORD $RDSPASSWORD
fi

# ignore requests against github.com
# TODO: maybe...re-evaluate this
echo -e "Host github.com\n\tStrictHostKeyChecking no\n" > ${HOMEDIR}/.ssh/config
