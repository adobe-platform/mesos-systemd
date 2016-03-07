#!/usr/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOMEDIR=$(eval echo "~`whoami`")
OWNER=$(whoami)

source /etc/environment

if [ ! -z $SECURE_FILES ]; then
    # have to use  us-east-1 - aws tool does not recognize anything else
    # for S3 download
    AWS_CREDS=""
    if [ ! -z $AWS_ACCESS_KEY ]; then
        AWS_CREDS=" -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY \
         -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY "
    fi
    sudo docker run --rm \
        -v ${HOMEDIR}:/data/  $AWS_CREDS behance/docker-aws-s3-downloader \
         us-east-1 $CONTROL_TIER_S3SECURE_BUCKET $SECURE_FILES

    # must chown all files to core for use
    FILES=(${SECURE_FILES//:/ })
    for file in "${FILES[@]}"; do
        PIECES=(${file//,/ })
        S3FILE=${PIECES[0]}
        PERMS=${PIECES[1]}
        TARGET=${PIECES[2]}

        if [ "${TARGET}" == "" ]; then
            TARGET="${S3FILE}"
        fi

        sudo chown -R ${OWNER}:${OWNER} ${HOMEDIR}/${TARGET}
    done
fi

# make sure that root has a .dockercfg
sudo cp /home/${OWNER}/.dockercfg /root/.

# ensure that we have a public key for our RSA key and that it's authorized
if [ -f ${HOMEDIR}/.ssh/id_rsa ]; then
    ssh-keygen -f ${HOMEDIR}/.ssh/id_rsa -y > ${HOMEDIR}/.ssh/id_rsa.pub
    cat ${HOMEDIR}/.ssh/id_rsa.pub >> ${HOMEDIR}/.ssh/authorized_keys
fi

# ignore requests against github.com
# TODO: maybe...re-evaluate this
echo -e "Host github.com\n\tStrictHostKeyChecking no\n" > ${HOMEDIR}/.ssh/config
