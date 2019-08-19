#This script installs the kubernetes cluster
OS on whicih this script was tested : Centos 7
Steps:
#This file has information how kubernetes cluster will be deployed with Nginx -Tomcat Pods with ssl.
#Tested on Centos 7

1. Install the k8s cluster using script "install_k8s_master.sh"
2. On node , install worker via script "install_k8s_node.sh"
3. Once cluster is installed now need to deploy the Pods, Dockerfiles are present in the directory from which images of nginx and tomcat are created and pushed to dockerhub.Static code and companyNews.war are deployed in the images which are pushed to dockerhub. 
4. in order to install and setup nginx,tomcat pods run python script "pod_deploy_service.py" this will deploy and service for both and images will get pulled from my dockerhub account.Python library "pathlib" is required to run without fail.
5. It will deploy nginx and tomcat pods.
6. add hosts file entry in nginx pod of tomcat pod's IP ( In normal enviroment this can be taken care via nopePOrt method and k8s DNS takes care of name resolution.)

In the pack there is one PPT which depicts about the architecture. 
in the hosts file of computer add hosts file entry again domain : myrealdomain.com after that try to access url https://myrealdomain.com:30010

github link: 

https://github.com/mintoozenith/kubernetes-master-install-shell-script



7. ONce installed copy the cluster join hash something like this:

kubeadm join 192.168.247.193:6443 --token nmf6tp.1101dqcc0w80cnmu \
    --discovery-token-ca-cert-hash sha256:ac120c896498d0b320a40fc8ca50ead164b1781e47bfbeee59642d29afaeda51

8. from worker node run above command ( Change IP address to your IP)

