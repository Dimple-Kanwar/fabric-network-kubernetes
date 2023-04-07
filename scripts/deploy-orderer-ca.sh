#!/bin/bash

# Exit on first error
set -euo pipefail

# Import common functions
. common.sh

# Read input parameters
if [ $# -lt 5 ]; then
  echo "Usage:" $0 "(environment name) (namespace) (ca name) (admin username) (admin password)"
  echo "Ex:" $0 "dev default orderer-ca admin adminpw"
  exit 1
fi

ENV_NAME=$1
NAMESPACE=$2
CA_NAME=$3
ADMIN_USERNAME=$4
ADMIN_PASSWORD=$5

HELMFILE_DIR=$PWD/../helmfiles

helmfile -f ${HELMFILE_DIR}/hf-ca-orderer.yaml -n ${NAMESPACE} -e ${ENV_NAME} --log-level ${LOG_LEVEL} \
  --state-values-set useExternalDB=${USE_EXTERNAL_DB},ordererCADBHost=${ORDERER_CA_DB_HOST},caPersistenceSize=${CA_PERSISTENCE_SIZE},caName=${CA_NAME},debug=${DEBUG},adminUsername=${ADMIN_USERNAME},adminPassword=${ADMIN_PASSWORD} sync

waitPodReady ${NAMESPACE} ${ENV_NAME}-${CA_NAME}

info "CA server: ${ENV_NAME}-${CA_NAME} started!"
