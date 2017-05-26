#!/bin/bash
# step 1: install ansible on control node
echo "*******************  step 1: install ansible on control node"
sudo apt-get install -y software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get -y  update
sudo apt-get install -y ansible

#step 2: ssh all nodes without password
echo "******************* step 2: ssh all nodes without password"
i=0
m=0
n=0
while read ip
do
   echo "************ "$ip
   temp=(${ip//,/ })
   ips[m]=${temp[0]}
   password[n]=${temp[1]}

  # echo "ip="${ips[m]}"************* pwd="${password[n]}
   i=$(($i+1))
   m=$(($m+1))
   n=$(($n+1))
done <$1

sudo apt-get install sshpass
yes "y" | ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
k=0
for a in ${ips[@]};do
  echo $a
  sshpass -p ${password[k]} ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@$a
done

#step 3: copy installation to other nodes
echo "*******************  step 3: copy installation to other nodes"
cd $2 && tar -zcvf installation.tar.gz installation

for a in ${ips[@]};do
   echo "***********   ip="$a
   scp /root/installation.tar.gz root@$a:/root
   ssh -o StrictHostKeyChecking=no root@$a "tar -zxvf /root/installation.tar.gz"
   ssh -o StrictHostKeyChecking=no root@$a "rm -r installation.tar.gz"
done
