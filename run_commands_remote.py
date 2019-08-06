#!/usr/bin/python
#Importing pssh library for running commands on remote servers in one go.

import psshlib
import sys
from pssh.clients import ParallelSSHClient
#Function defination for concurrent ssh to multiple nodes and get the computerparseble output
def ssh(hosts, command):
        client = ParallelSSHClient(hosts, user='user', password='passwd')
        output = client.run_command(command)
	for host, host_output in output.items():
                for line in host_output.stdout:
                        print line
	f = open("Computer_Parseble_OUTPUT", "w")
        f.write(str(output))
        f.close()

# Reading commandis to run from user 
harmless = ['ls','date']
caution = ['rm', 'fsck']
print ("Please enter command in '' to execute")
command = input()

#Declaring all hosts in a List
all_hosts=[]
f = open('hosts_list','r')
for lines in f:
    all_hosts.append(lines.strip('\n'))
all_hosts.sort()

if command in harmless:
	print ("You have entered Harmeless command, Hence running command on 200 hosts")
	print("###################################################################")
	n=0
	while n < (len(all_hosts)):
		hosts = all_hosts[n:n+200]
		n=n+200
#Function call to ssh on remote hosts
		ssh(hosts, command)
#For caution command converting list of servres in dictionary
dict = { }
if command in caution:
	print("You have entered the command which needs caution, Hence ruuning this command at below servers ,one node at a time")
	print("###################################################################")

	for value in all_hosts:
    		key = (value[8:13])
	        if key in dict:
	            dict[key].append(value)
		else:
		    dict[key] = [value]
			
	print(dict)
	for itr in range(40):
		hosts=[]
        	for loop in dict:
			try:
				hosts.append(dict[loop][itr])	
			except IndexError:
				continue
		if len(hosts)== 0:
			break
#Function call to ssh on remote hosts hosts
		ssh(hosts, command)
