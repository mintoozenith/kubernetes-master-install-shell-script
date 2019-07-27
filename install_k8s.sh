#!/bin/bash
#Shell Script to setup the kubernetes cluster.
#This Script has to be executed on Kubernetes Master node.
#Auther : Rajesh

#Disable SELinux & setup firewall rules
#set -x
#set -v

hostnamectl set-hostname 'k8s-master'
#exec bash
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

#Add the required FW rules

echo "Setting up required FW Rules..."

firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10251/tcp
firewall-cmd --permanent --add-port=10252/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --reload
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

echo "FW Rules Added..."

#Checking the Pre-Requisite for Kubernetes Installation
#Check if minimum CPUs there on Server.


CPU_COUNT=`nproc`
echo $CPU_COUNT  >/dev/null 2>&1

if [ $CPU_COUNT -lt 2 ]
 then

    echo "Sorry Your Server is not having required minimum CPU(2), Script now will exit"
    exit

else
    echo "Required minium CPUs are Validated.. Going Ahead with Install"
fi

#Turning off SWAP
swapoff -a

# Configure the Kubernetes Repository

echo  " [kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg"  > /etc/yum.repos.d/kubernetes.repo
 


echo "Kubernetes Repository added.."
echo "#############################"
sleep 10

#Install and start-enable services KubeAdm and Docker

yum install kubeadm docker -y

#Enable Docker service at boot time


systemctl restart docker && systemctl enable docker

if [ $? == 0 ]; then
echo "Docker service Enabled at boot time"
echo "###############################"
else
echo "There Seems some issue Enabling the docker service"
fi
#initialise the cluster
kubeadm init

#Configure the API-Server 
mkdir -p $HOME/.kube
cp -r /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

#get the status of the pod and nodes
kubectl get nodes -o wide
#Deploy the network

echo " Deploying the Network"
echo "##############################"

export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

#Check status of the master NODE
KUBE=`kubectl get nodes` 
$KUBE
