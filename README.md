# Install RackHD With Ansible 

Ansible is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments. Ansible and shell scripts are used to install RackHD with source code. These scripts will be introduced.

* http://docs.ansible.com/ansible/ -- Ansible Doc

## Preparation

Before ansible is used to install RackHD, some steps need to be done.

* edit /etc/ansible/hosts, define hosts where RackHD will be installed.
* ensure ssh these ips defined in "/etc/ansible/hosts"
   
        yes "y" | ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
   
        sshpass -p <password> ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@<IP>




## install_rackhd.yml

The ansible script is used to install RackHD with source code. User can execute the command to install RackHD:

	ansible-playbook install_rackhd.yml

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

## how to install RacKHD with these scripts

* step 1: execute the shell script in ansible control node:

        /bin/bash pre_install.sh ips /root

* step 2: change the hosts file of ansible: ~/etc/ansible/hosts

Note: promise that the ip list in hosts are consistent with ip list in `ips` file.

* step 3: execute the ansible script in ansible control node to start installing RackHD

        ansible-playbook install_rackhd.yml

* step 4: valiate if RackHD is installed successfully.
    
        ~/src/npm/bin/pm2 status
