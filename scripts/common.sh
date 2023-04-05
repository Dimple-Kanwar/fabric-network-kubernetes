#!/bin/bash

# Exit on first error
set -euo pipefail


function waitPodReady() {
	local NAMESPACE=$1
	local RELEASE_NAME=$2
	local POD_NAME=`kubectl get pods -n ${NAMESPACE} -l "release=${RELEASE_NAME}" -o jsonpath="{.items[0].metadata.name}"`
  
	kubectl -n ${NAMESPACE} wait --timeout=300s --for=condition=Ready pod/${POD_NAME}
}
