#!/bin/bash
#Shell Script to setup the kubernetes node.
#This Script has to be executed on Kubernetes worker node.
#Author : Rajesh Kumar

echo "Setting up the pre-requsite for the install"
echo "###########################################"
echo "###########################################"

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --permanent --add-port=30000-32767/tcp
firewall-cmd --permanent --add-port=6783/tcp
firewall-cmd  --reload
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

#Checking the required CPUs for install

CPU_COUNT=`nproc`
echo $CPU_COUNT  >/dev/null 2>&1

if [ $CPU_COUNT -lt 2 ]
 then

    echo "Sorry Your Server is not having required minimum CPU(2), Script now will exit"
    exit

else
    echo "Required minium CPUs are Validated.. Going Ahead with Install"
fi

##Add the HOSTS file entry with IP and the hostname

IP=`hostname -I | awk '{print $1}'`
HOST="node-01"
echo  "$IP $HOST" > /etc/hosts


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

#Install kubeadm and docker package on both nodes
yum install kubeadm docker


#Start and enable docker service

systemctl restart docker && systemctl enable docker
