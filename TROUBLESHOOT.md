Error: 
    INSTALLATION FAILED: persistentvolumeclaims "orderer-ca-hlf-ca" is forbidden: Internal error occurred: 2 default StorageClasses were found
Solution:
    kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
Error: 
    helm microk8s kubernetes cluster unreachable
Solution:
    kubectl config view --raw > ~/.kube/config