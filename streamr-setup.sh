#!/bin/bash -x
export BENEFICIARY_KEY=0xe726E6E6C9A1Cc2bcDeDed6FeBA5bEC5f51de89b

BENEFICIARY_KEY=${1}

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
sed -i 's@"brubeckMiner": {}@"brubeckMiner": {"beneficiary_address": "'${BENEFICIARY_KEY}'"}@'t ${LOCAL_DIR}/config/default.json

# run streamr node with as a daemon process with the --restart option and unique name
docker run -dt --name ${NODE_NAME}  --restart unless-stopped -v ${LOCAL_DIR}:${CONTAINER_DIR} streamr/broker-node:latest

