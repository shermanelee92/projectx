#!/bin/sh
echo "creating ssh key for hadoop-master"
docker exec -it hadoop-master ssh-keygen -t rsa -b 4096
echo "moving ssh key for hadoop-master"
docker exec hadoop-master bash -c 'cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys'
echo "change owner for hadoop-master"
docker exec hadoop-master bash -c 'chmod og-wx ~/.ssh/authorized_keys'
docker exec hadoop-master bash -c 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no localhost'

hadoop_master_ip=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' hadoop-master)
hadoop_slave1_ip=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' hadoop-slave1)
# hadoop_slave2_ip=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' hadoop-slave2)

hadoop_master_ip_host="$hadoop_master_ip  hadoop-master"
hadoop_slave1_ip_host="$hadoop_slave1_ip  hadoop-slave1"
# hadoop_slave2_ip_host="$hadoop_slave2_ip  hadoop-slave2"

docker exec hadoop-master bash -c "echo $hadoop_slave1_ip_host >> /etc/hosts"
docker exec hadoop-master bash -c "echo $hadoop_slave2_ip_host >> /etc/hosts"
docker exec hadoop-slave1 bash -c "echo $hadoop_master_ip_host >> /etc/hosts"
docker exec hadoop-slave2 bash -c "echo $hadoop_master_ip_host >> /etc/hosts"


# ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.21.0.3
