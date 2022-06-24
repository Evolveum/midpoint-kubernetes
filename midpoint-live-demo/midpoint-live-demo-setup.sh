#!/bin/bash

# Import of namespaces and nfs objects
kubectl apply -f $PWD/namespaces
kubectl apply -f $PWD/objects/nfs

# Import of midpoint internal objects in config maps. These are extensions, post initial objects and initial hr resources.
kubectl create configmap -n mp-demo pio-map --from-file=$PWD/objects/mp/config-map/mp-post-initial-objects
kubectl create configmap -n mp-demo extension-map --from-file=$PWD/objects/mp/config-map/mp-extensions
kubectl create configmap -n mp-demo hr-map --from-file=$PWD/objects/mp/config-map/mp-hr

# Import of midpoint kubernetes objects
kubectl apply -f $PWD/objects/mp/yamls

# Import adressbook database initial script as config map 
kubectl create configmap -n mp-demo addressbook-script-map --from-file=$PWD/objects/addressbook/config-map

# Import of adressbook kubernetes objects
kubectl apply -f $PWD/objects/addressbook/yamls

# Import of hr database initial script as config map
kubectl create configmap -n mp-demo hr-script-map --from-file=$PWD/objects/hr/config-map

# Import of hr kubernetes objects
kubectl apply -f $PWD/objects/hr/yamls

# Import of httpd.conf file for apache server as config map
kubectl create configmap -n mp-demo apache-map --from-file=$PWD/objects/apache/config-map

# Import of apache server kubernetes objects
kubectl apply -f $PWD/objects/apache/yamls

# Import of ldap initial objects as config map
kubectl create configmap -n mp-demo ldap-init-map --from-file=$PWD/objects/ldap-init/config-map

# Import of dynschema for ldap as config map
kubectl create configmap -n mp-demo ldap-dynschema-map --from-file=$PWD/objects/ldap-dynschema/config-map

# Import of ldap kuberntes objects
kubectl apply -f $PWD/objects/ldap/yamls

# Import of tomcat kubernetes objects
kubectl apply -f $PWD/objects/tomcat






