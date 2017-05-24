# Install RackHD With Ansible

Ansible is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments. Ansible and shell scripts are used to install RackHD with source code. These scripts will be introduced.

* http://docs.ansible.com/ansible/ -- Ansible Doc

## pre_install.sh

The script is used to finish the following tasks:

* install ansible in control node.
* ssh all nodes without password.
* copy installation to other nodes.

The script is executed before installing RackHD. Users can execute the following command to execute the script    
	
	/bin/bash pre_install.sh ips /root

The script has two args,namely: ips and /root. `ips` is a text file which contains ip and password(root authority). For example, one line of the ips file: 10.62.60.52,123456.

The second arg is the directory of installation.

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
