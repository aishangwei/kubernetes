#!/bin/bash

yum -y install wget

# 配置 k8s 源
cat > /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
EOF

# 配置 docker 源
wget  -O /etc/yum.repos.d/docker-ce.repo   https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 安装软件
yum -y install docker-ce kubeadm kubectl kubelet
systemctl enable docker kubelet && systemctl start docker

# 配置加速器
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://g9ppwtqr.mirror.aliyuncs.com"]
}
EOF

 sudo systemctl daemon-reload && systemctl restart docker







