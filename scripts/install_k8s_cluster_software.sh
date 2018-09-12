#!/bin/bash
# Author: aishangwei
# Data: 2018/9/12 21:13
# Des: 安装k8s集群所需的软件
#

#################################################
NODE1="192.168.20.148"
NODE2="192.168.20.149"
#################################################

# 安装基础软件
yum -y install wget


# 配置 k8s 源
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
EOF


# 配置 docker 源
wget  -O /etc/yum.repos.d/docker-ce.repo   https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo


scp /etc/yum.repos.d/{kubernetes.repo,docker-ce.repo} ${NODE1}:/etc/yum.repos.d/
scp /etc/yum.repos.d/{kubernetes.repo,docker-ce.repo} ${NODE2}:/etc/yum.repos.d/

yum -y install docker-ce kubeadm kubectl kubelet
systemctl enable docker kubelet
systemctl start docker

tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://g9ppwtqr.mirror.aliyuncs.com"]
}
EOF

systemctl daemon-reload
systemctl restart docker









