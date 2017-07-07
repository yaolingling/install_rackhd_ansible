# Install RackHD With Ansible 

Ansible is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments. Ansible is used to install RackHD with source code on ubuntu and Vagrant.

* ansible - http://docs.ansible.com/ansible/
* Vagrant - https://www.vagrantup.com/

## Preparation

Before ansible is used to install RackHD, some steps need to be done.

       sudo apt-get install software-properties-common
       sudo apt-add-repository ppa:ansible/ansible 
       sudo apt-get update
       sudo apt-get install ansible

After ansible is installed, you can check if ansible is installed successfully.
 
       sudo ansible --version

Set up RackHD on ubuntu,

* edit "vi /etc/ansible/hosts", define hosts where RackHD will be installed. If you want to install RackHD in localhost and remote nodes. You can add the followings lines in '/etc/ansible/hosts'. 'vms' is defined in line 4 of the file 'install_rackhd_ubuntu.yml'.

        [vms]
        localhost
        <node IP1>
        <node IP2>

* ensure ssh these ips defined in "/etc/ansible/hosts" without password. You need to replace the '<IP>' of the second command with the ip defined in the file 'install_rackhd_ubuntu.yml'. '<password>' needed to be replaced with the ssh password of this node.
   
        sudo yes "y" | ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
   
        sudo sshpass -p <password> ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@<IP>

* check the line which contains "127.0.0.1 localhost" in the file "/etc/hosts", add <hostname> 
      
        127.0.0.1 localhost <hostname>


There is no preparations for setting up RackHD on Vagrant

## install_rackhd_ubuntu.yml

The file is used to install RackHD with source code in fresh ubuntu. User can execute the command to install RackHD:

	sudo ansible-playbook install_rackhd_ubuntu.yml

The ansible script contains the following roles:

* apt - update apt repo
* build - install apt,build-essential
* isc-dhcp-server - install dhcp server
* mongodb - install mongodb
* rabbitmq-server - install rabbitmq server
* impitool - install impitool
* snmp - install snmp
* configNetwork - config network and restart dhcp service
* nodejs - install v4 nodejs
* cloneCode - clone source code from github
* dependency - install dependency for repos
* config_file - create rackhd config file: config.json
* static_files - wget static files to local
* pm2 - install pm2 and start rackhd
* start-rackhd - start RackHD

## install_rackhd_vagrant.yml

The file is used to install RackHD in vagrant. The file shares the modules in folder'roles' with the yml,"install_rackhd_ubuntu.yml". The ansible script runs in Vagrant to install RackHD. Users can execute the command to set up RackHD which runs in vagrant box.
   
        sudo vagrant up dev_ansible


## how to install RacKHD

### For setting up RackHD which runs on frash ubuntu

* step 1: change the hosts file of ansible: ~/etc/ansible/hosts

Note: promise that the ip list in hosts are consistent with ip list in `ips` file.

* step 2: ssh these nodes defined in /etc/ansible/hosts without password.

* step 3: execute the ansible script in ansible control node to start installing RackHD

        sudo ansible-playbook install_rackhd.yml

* step 4: valiate if RackHD is installed successfully.
    
        sudo pm2 status

### For setting up RackHD which runs in vagrant box

* step 1: set up a vagrant box used to install RackHD
  
       sudo vagrant up dev_ansible

* step 2: check whether RackHD is installed successfully

       sudo ssh dev_ansible
       sudo su
       pm2 status
