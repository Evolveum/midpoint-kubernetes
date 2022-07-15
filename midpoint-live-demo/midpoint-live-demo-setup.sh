#!/bin/bash

while getopts n:s:c:a:h flag
do
    case "${flag}" in
        n) NAMESPACE=${OPTARG};;
        s) SERVER=${OPTARG};;
        c) CERTADDRESS=${OPTARG};;
        a) HOST=${OPTARG};;
        h | *)
          echo "script usage:"
          echo "$0 [-s value] [-n value]"
          echo "-n 	 custom namespace in which demo would be deployed. Default namespace is mp-demo"
          echo "-s 	 custom nfs server address. Default is nfs-service.<YOUR NAMESPACE>.svc.cluster.local"
          echo "-c 	 custom yaml certificate for ingresses. Default certificate is packed with demo. PLEASE USE THE SAME NAME FOR THE FILE AND THE KUBERNETES OBJECT"
          echo "-a 	 custom host for ingresses. Default host is demo.example.com. Please be aware that default certificate does work only with default host"
          ;; 
    esac
done

if [ -z $NAMESPACE ]
then
   NAMESPACE=mp-demo
fi

if [ -z $HOST ]
then
   HOST="demo.example.com"
fi

sed -i "s/ingress_host: .*/ingress_host: $HOST/g" config-files/options-map.yaml

if [ -z $NAMESPACE ]
then
   NAMESPACE="mp-demo"
fi

if [ $CERTADDRESS ]
then
   kubectl apply -f $CERTADDRESS -n $NAMESPACE 2> /dev/null || true
   CERT=$(basename $CERTADDRESS)
else
   CERT="cert-mp-demo"
fi

sed -i "s/ingress_cert: .*/ingress_cert: $CERT/g" config-files/options-map.yaml

if [ $SERVER ]
then
   sed -i "s/nfs_server: .*/nfs_server: $SERVER/g" config-files/options-map.yaml
else
   sed -i "s/nfs_server: .*/nfs_server: nfs-service.$NAMESPACE.svc.cluster.local/g" config-files/options-map.yaml
fi

kubectl create namespace $NAMESPACE 2> /dev/null || true
kubectl apply -k ./base/ -n $NAMESPACE
