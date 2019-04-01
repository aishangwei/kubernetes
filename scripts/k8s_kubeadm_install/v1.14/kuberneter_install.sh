#!/bin/bash
yum install -y yum-utils device-mapper-persistent-data lvm2

cat > /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
EOF

curl -o  /etc/yum.repos.d/docker-ce.repo   https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum -y install kubeadm-1.14.0 kubectl-1.14.0 kubelet-1.14.0  docker-ce-18.09.3-3.el7

# 创建文件夹
if [ ! -d "/etc/docker" ];then
    mkdir -p /etc/docker
fi

# 配置 docker 启动参数
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
  "max-size": "100m"
  },
    "storage-driver": "overlay2"
  }
EOF


# 配置开启自启
systemctl enable docker && systemctl enable kubelet
systemctl daemon-reload 
systemctl restart docker
