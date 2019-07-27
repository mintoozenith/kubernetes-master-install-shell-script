#This script installs the kubernetes cluster
OS on whicih this script was tested : Centos 7
Steps:

1. Copy the script "install_k8s_master.sh"in which ever directory you want
2. Run the script using "bash ./"install_k8s_master.sh"in"
3. This will take care of installing the kubernetes cluster 
4. ONce installed copy the cluster join hash something like this:

kubeadm join 192.168.247.193:6443 --token nmf6tp.1101dqcc0w80cnmu \
    --discovery-token-ca-cert-hash sha256:ac120c896498d0b320a40fc8ca50ead164b1781e47bfbeee59642d29afaeda51

5. from worker node run above command ( Change IP address to your IP)

