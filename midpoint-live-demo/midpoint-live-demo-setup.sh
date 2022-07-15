#!/bin/bash

while getopts n:s:h flag
do
    case "${flag}" in
        n) NAMESPACE=${OPTARG};;
        s) SERVER=${OPTARG};;
        h | *)
          echo "script usage:"
          echo "$0 [-s value] [-n value]"
          echo "-n 	 custom namespace in which demo would be deployed. Default namespace is mp-demo"
          echo "-s 	 custom nfs server address. Default is nfs-service.<YOUR NAMESPACE>.svc.cluster.local"
          ;; 
    esac
done

if [ -n $SERVER ]
then
   sed -i "s/nfs_server: .*/nfs_server: $SERVER/g" base/nfs-server-map.yaml
elif [ -n $NAMESPACE ]
then
   sed -i "s/nfs_server: .*/nfs_server: nfs-service.$NAMESPACE.svc.cluster.local/g" base/nfs-server-map.yaml
fi

if [ -n $NAMESPACE ]
then
   sed -i "s/name: .*/name: $NAMESPACE/g" base/namespaces/namespace.yml
   kubectl apply -k ./base/ -n $NAMESPACE
else
   kubectl apply -k ./base/ -n mp-demo
fi
