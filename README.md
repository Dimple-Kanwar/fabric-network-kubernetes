# fabric-network-kubernetes
Hyperledger fabric operator in kubernetes

Pull charts from remote artifacts repo
    helm pull owkin/hlf-ca --untar

Deploy ca-orderer:
  helmfile apply -f hf-ca-orderer.yaml --state-values-set "useExternalDB=false,caPersistenceSize=1Gi,ordererCADBHost=localhost" --namespace mynamespace --environment dev

  helmfile -f ${HELMFILE_DIR}/10-hlf-ca-orderer.yaml -n ${NAMESPACE} -e ${ENV_NAME} --log-level ${LOG_LEVEL} \
  --state-values-set useExternalDB=${USE_EXTERNAL_DB},ordererCADBHost=${ORDERER_CA_DB_HOST},caPersistenceSize=${CA_PERSISTENCE_SIZE} sync

Uninstall the release:
    helm uninstall dev-ca-orderer -n mynamespace


helm list -n mynamespace