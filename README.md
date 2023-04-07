# fabric-network-kubernetes
Hyperledger fabric operator in kubernetes

Pull charts from remote artifacts repo
    helm pull owkin/hlf-ca --untar

Prepare environment file:
  cp .env_sample .env

Deploy via shell script:
  chmod +x ./scripts/*
  ./scripts/deploy-orderer-ca.sh dev default orderer1-ca admin adminpw

Deploy ca-orderer using helmfile:
  helmfile apply -f hf-ca-orderer.yaml --state-values-set "useExternalDB=false,caPersistenceSize=1Gi,ordererCADBHost=localhost" --namespace default --environment dev

Deploy ca-orderer using helm:
  helm install dev-ca-orderer hlf-ca --set "caName=dev-ca-orderer"

After ca deploy to test the ca deployment:

Run the following commands to...
1. Get the name of the pod running the Fabric CA Server:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=hlf-ca,release=orderer-ca" -o jsonpath="{.items[0].metadata.name}")

2. Get the application URL:
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl port-forward --namespace default $POD_NAME 8080:7054

3. Display local (admin "client" enrollment) certificate, if it has been created:
  kubectl exec --namespace default $POD_NAME -- cat /var/hyperledger/fabric-ca/msp/signcerts/cert.pem

4. Enroll the bootstrap admin identity:
  kubectl exec --namespace default $POD_NAME -- sh -c 'fabric-ca-client enroll -d -u http://$CA_ADMIN:$CA_PASSWORD@$SERVICE_DNS:7054'

5. Update the chart without resetting a password:
  export CA_ADMIN=$(kubectl get secret --namespace default orderer-ca-hlf-ca--ca -o jsonpath="{.data.CA_ADMIN}" | base64 --decode; echo)
  export CA_PASSWORD=$(kubectl get secret --namespace default orderer-ca-hlf-ca--ca -o jsonpath="{.data.CA_PASSWORD}" | base64 --decode; echo)
  helm upgrade orderer-ca hlf-ca --namespace default --set adminUsername=$CA_ADMIN,adminPassword=$CA_PASSWORD


Uninstall the release:
    helm uninstall dev-ca-orderer -n default

To list the releases in namespace `default` :
  helm list -n default