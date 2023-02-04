#!/bin/bash 

# script will
# - load latest docker image for streamr
# - create diectory ~/.streamRXXXX using the last four characters of the beneficiary key i
#   as unique ID XXXX
# - will run container with broker wizard ( usually press enter few times to accept defaults )
# - will add beneficiary key into config/default.json file
# - create and start docker container with the name streamRXXXX
#
#   test if container is running:
#       docker ps
#   test container logs
#       docker logs streamRXXXX
#
# NOTE: you need to have docker installed and have permissions to run docker commands

# set -x

if [ $# -eq 0 ]
then
    echo  "Usage: "
    echo  "${0} <BENEFICIARY_KEY> "
    exit 1
fi

BENEFICIARY_KEY=${1}

n=${#BENEFICIARY_KEY};

if [ $n -lt 10 ] 
then
    echo  "<BENEFICIARY_KEY> is too short"
    exit 1
fi
	
# get last 4 characters of the key for unique node name
export tmp=${BENEFICIARY_KEY:0-4}

export NODE_NAME="streamR${tmp}"

export CONTAINER_DIR="/home/streamr/.streamr"

export LOCAL_DIR="$(cd ~/ ;pwd)/.${NODE_NAME}"

mkdir ${LOCAL_DIR} 
chmod 777 ${LOCAL_DIR}

# Run node setup wizard - press Enter for all defaults
docker run -it -v ${LOCAL_DIR}:${CONTAINER_DIR} streamr/broker-node:latest bin/config-wizard

# add beneficiary public key to the config
sed -i 's@"brubeckMiner": {}@"brubeckMiner": {"beneficiaryAddress": "'${BENEFICIARY_KEY}'"}@' ${LOCAL_DIR}/config/default.json

# run streamr node with as a daemon process with the --restart option and unique name
docker run -dt --name ${NODE_NAME}  --restart unless-stopped -v ${LOCAL_DIR}:${CONTAINER_DIR} streamr/broker-node:latest

