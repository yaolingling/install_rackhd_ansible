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

**Set up RackHD on ubuntu**,

* Make sure that there are two network interfaces.
 
Usually we setup a dedicated network for RackHD (we call it RackHD control network), the isc-dhcp-server should only work within this network and all RackHD controlled nodes should be put within this network as well.You need to ensure that the node has two network interfaces. Ubuntu 16.04 and Ubuntu 14.04 have different naming for network interfaces, we usually see eth0 and eth1 in Ubuntu 14.04, however enp0s3, enp0s8 in 16.04. In 16.04, the name has some relation with the real hardware config, so you may see other names.

* Config the nodes that needs to install RackHD.

edit "vi /etc/ansible/hosts", define hosts where RackHD will be installed. If you want to install RackHD in localhost and remote nodes. You can add the followings lines in '/etc/ansible/hosts'. 'vms' is defined in line 4 of the file 'install_rackhd_ubuntu.yml'.

        [vms]
        localhost
        <node IP1>
        <node IP2>

* Make sure that ssh root@ip without password
 
step 1: ensure ssh nodes defined in '/etc/ansible/hosts' with root. Commands below need to be executed on every node defined in the file '/etc/ansible/hosts'. If you can ssh nodes with root, you can skip this step.
    
        sudo passwd root        
        sudo apt-get update
        sudo apt-get install openssh-server

Then "sudo vi /etc/ssh/sshd_config". In this file, change the line contains 'PermitRootLogin' to 'PermitRootLogin yes'. Finally, "sudo service ssh restart".

step 2: ensure ssh these ips defined in "/etc/ansible/hosts" without password. You need to replace the '<IP>' of the last command with the ip defined in the file 'install_rackhd_ubuntu.yml'. '<password>' needed to be replaced with the ssh password of this node.

        sudo su
        apt-get update
        apt-get install sshpass
        yes "y" | ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
        sshpass -p <password> ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@<IP>

step 3: Check if ssh nodes defined in '/etc/ansible/hosts' without password, for example:

        sudo ssh root@localhost
        sudo ssh root@<node IP1>
        sudo ssh root@<node IP2>

* Add `hostname` in `/etc/hosts`
 
For every node defined in /etc/ansible/hosts, check the line which contains "127.0.0.1 localhost" in the file "/etc/hosts", add <hostname>. You can execute the command 'hostname' to get hostame. 
      
        127.0.0.1 localhost <hostname>


**Set up RackHD in vagrant**, 

You need to install [vagrant](https://www.vagrantup.com/) (version >= 1.8.0) and [VirturalBox](https://www.virtualbox.org/wiki/VirtualBox) (version: 4.3.X).


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

* step 1: change the hosts file of ansible: /etc/ansible/hosts

Note: promise that the ip list in hosts are consistent with ip list in the file `/etc/ansible/hosts`.

* step 2: ssh these nodes defined in /etc/ansible/hosts without password.

* step 3: execute the ansible script in ansible control node to start installing RackHD

        sudo ansible-playbook install_rackhd_ubuntu.yml

* step 4: valiate if RackHD is installed successfully.
    
        sudo pm2 status

### For setting up RackHD which runs in vagrant box

* step 1: set up a vagrant box used to install RackHD
  
       sudo vagrant up dev_ansible

* step 2: check whether RackHD is installed successfully

       sudo ssh dev_ansible
       sudo su
       pm2 status
