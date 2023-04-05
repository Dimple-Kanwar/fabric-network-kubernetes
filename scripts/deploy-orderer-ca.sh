#!/bin/bash

# Exit on first error
set -euo pipefail

# Import common functions
. common.sh

# Read input parameters
if [ $# -lt 1 ]; then
  echo "Usage:" $0 "(environment name)"
  echo "Ex:" $0 "dev"
  exit 1
fi

ENV_NAME=$1
NAMESPACE=$2

HELMFILE_DIR=${PWD}/../helmfiles

helmfile -f ${HELMFILE_DIR}/hlf-ca-orderer.yaml -n ${NAMESPACE} -e ${ENV_NAME} --log-level ${LOG_LEVEL} \
  --state-values-set useExternalDB=${USE_EXTERNAL_DB},ordererCADBHost=${ORDERER_CA_DB_HOST},caPersistenceSize=${CA_PERSISTENCE_SIZE} sync

waitPodReady ${NAMESPACE} ${ENV_NAME}-ca-orderer

info "CA server: ${ENV_NAME}-ca-orderer started!"
