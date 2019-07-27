#!/bin/bash

KUBE_RPM=`rpmquery kubeadm`
KUBE_RPM_INS=`rpmquery  kubeadm | wc -l`
DOCKER_RPM=`rpmquery docker`
DOCKER_RPM_INS=`rpmquery docker | wc -l`

if [ "$KUBE_RPM_INS" > 0 ];then

echo "Kubeadmn package is installed"

echo "Uninstaling the package"
yum remove $KUBE_RPM
    if [ "$DOCKER_RPM_INS" > 0 ];then
    echo "Docker package  is already Installed"
    echo "Uninstaling the package"
    yum remove $DOCKER_RPM
  fi 
#else
echo "Kubeadm and Docker packages not found, Installing them"
echo "##################################################"

yum install kubeadm docker
fi

FILES="/etc/kubernetes/manifests/*"
COUNT=`ls $FILES | wc -l`
FILE_ETCD="/var/lib/etcd/"
FILE_ETCD_COUNT=`ls $FILE_ETCD | wc -l`
if [ $COUNT > 2 ];then
echo "KUBERNETES Files already exist, Hence deleting them from clean install of K8S cluster"
rm -rf $FILES
    if [ $FILE_ETCD_COUNT > 2 ];then
    echo "Cleaning up the ETCD Pre-installed directory"
    rm -rf $FILE_ETCD
    fi
fi
