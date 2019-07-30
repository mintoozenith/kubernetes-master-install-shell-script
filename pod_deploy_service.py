#!/usr/bin/python
import os
import os.path
from pathlib import Path
#os.path.isfile(fname)


def deployment(dep):
    PATH = "/root/nginx/"+dep+"-deployment.yaml"
    file = PATH
    print(file)
    if os.path.isfile(PATH) and os.access(PATH, os.R_OK):
        print("YAML SERVICE file found, creating DEPLOYMENT using this YAML File")
	print("#############################################################")
        cmd = "kubectl create -f" + file
	os.system(cmd)
    else:
	print("YAML DEPLOYMENT file does not exist, please make sure file exists")

deployment("nginx")
deployment("tomcat")

def service(ser):
    PATH = "/root/nginx/"+ser+"-service.yaml"
    file = PATH
    print(file)
    if os.path.isfile(PATH) and os.access(PATH, os.R_OK):
        print("YAML SERVICE file found, creating SERVICE using this YAML File")
	print("#############################################################")
        cmd = "kubectl create -f" + file
        os.system(cmd)
    else:
	print("YAML SERVICE file does not exist, please make sure file exists")

service("nginx")
service("tomcat")
