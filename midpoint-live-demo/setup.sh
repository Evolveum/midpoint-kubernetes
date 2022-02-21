#!/bin/bash

kubectl apply -f $PWD/namespaces
kubectl apply -f $PWD/objects/nfs

kubectl create configmap -n mp-demo pio-map --from-file=$PWD/config-maps/mp-pio
kubectl create configmap -n mp-demo extension-map --from-file=$PWD/config-maps/mp-extensions
kubectl create configmap -n mp-demo hr-map --from-file=$PWD/config-maps/mp-hr
kubectl create configmap -n mp-demo addressbook-script-map --from-file=$PWD/config-maps/addressbook
kubectl create configmap -n mp-demo hr-script-map --from-file=$PWD/config-maps/hr
kubectl create configmap -n mp-demo apache-map --from-file=$PWD/config-maps/apache
kubectl create configmap -n mp-demo ldap-init-map --from-file=$PWD/config-maps/ldap-init
kubectl create configmap -n mp-demo ldap-dynschema-map --from-file=$PWD/config-maps/ldap-dynschema

kubectl apply -Rf $PWD/objects






