#!/bin/bash

NAMESPACE=mp-demo
HOST=demo.example.com

while getopts n:s:c:a:i:h flag
do
    case "${flag}" in
        n) NAMESPACE=${OPTARG};;
        s) SERVER=${OPTARG};;
        c) CERTADDRESS=${OPTARG};;
        a) HOST=${OPTARG};;
        i) INGRESSCLASS=${OPTARG};;
        h | *)
          echo "script usage:"
          echo "$0 [-s value] [-n value]"
          echo "-n 	 custom namespace in which demo would be deployed. Default namespace is mp-demo"
          echo "-s 	 custom nfs server address. Default is nfs-service.<YOUR NAMESPACE>.svc.cluster.local"
          echo "-c 	 custom yaml certificate for ingresses. Default certificate is packed with demo. PLEASE USE THE SAME NAME FOR THE FILE AND THE KUBERNETES OBJECT"
          echo "-a 	 custom host for ingresses. Default host is demo.example.com. Please be aware that default certificate does work only with default host"
          echo "-i    custom ingressClass name. Default is default on your machine (one with annotation ingressclass.kubernetes.io/is-default-class: true). Make sure that you do have ONE default ingressClass or use this option to set a custom one."
          ;; 
    esac
done

sed -i "s/ingress_host: .*/ingress_host: $HOST/g" kustomize-env-config/options-map.yaml

if [ -z $INGRESSCLASS ]
then
   INGRESSCLASS=$(kubectl get ingressClass -o=jsonpath='{.items[?(@.metadata.annotations.ingressclass\.kubernetes\.io/is-default-class=="true")].metadata.name}')
fi

sed -i "s/ingress_class_name: .*/ingress_class_name: $INGRESSCLASS/g" kustomize-env-config/options-map.yaml

if [ $CERTADDRESS ]
then
   kubectl apply -f $CERTADDRESS -n $NAMESPACE 2> /dev/null || true
   CERT=$(basename $CERTADDRESS)
else
   mkdir kustomize-env-config/certificate/ 2> /dev/null || true
   cd kustomize-env-config/certificate/
   openssl req -new -sha256 -newkey rsa:2048 -keyout tls.key -nodes -subj "/CN=test CA" | openssl x509 -req \
   -signkey tls.key -out tls.crt -days 3650 -sha256 -extfile <(cat <<EOF
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer:always
keyUsage = digitalSignature, nonRepudiation, keyEncipherment
subjectAltName = DNS:demo.example.com
extendedKeyUsage = serverAuth
EOF
)
   kubectl create secret tls -n $NAMESPACE cert-mp-demo --cert=tls.crt --key=tls.key
   cd ../..
   CERT="cert-mp-demo"
fi

sed -i "s/ingress_cert: .*/ingress_cert: $CERT/g" kustomize-env-config/options-map.yaml

if [ $SERVER ]
then
   sed -i "s/nfs_server: .*/nfs_server: $SERVER/g" kustomize-env-config/options-map.yaml
else
   sed -i "s/nfs_server: .*/nfs_server: nfs-service.$NAMESPACE.svc.cluster.local/g" kustomize-env-config/options-map.yaml
fi

kubectl create namespace $NAMESPACE 2> /dev/null || true
kubectl apply -k ./base/ -n $NAMESPACE