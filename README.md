# fabric-network-kubernetes
Hyperledger fabric operator in kubernetes

Pull charts from remote artifacts repo
    helm pull owkin/hlf-ca --untar

Deploy ca-orderer:
  helmfile apply -f hf-ca-orderer.yaml --state-values-set "useExternalDB=true,caPersistenceSize=1Gi,ordererCADBHost=localhost" --namespace mynamespace --environment dev