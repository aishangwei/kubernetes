#!/bin/bash

# 安装依赖包
source ../00_cluster_env.sh
for ip in ${NODE_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh root@${ip} "yum install -y epel-release"
    ssh root@${ip} "yum install -y conntrack ipvsadm ipset jq iptables curl sysstat libseccomp && /usr/sbin/modprobe ip_vs "
  done

# 安装 docker
wget https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz
tar -xvf docker-18.03.1-ce.tgz

source ../00_cluster_env.sh
for ip in ${NODE_IPS[@]}
  do
    echo ">>> ${ip}"
    scp docker/docker*  k8s@${ip}:/opt/k8s/bin/
    ssh k8s@${ip} "chmod +x /opt/k8s/bin/*"
  done

# 创建服务文件
cat > docker.service <<"EOF"
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io

[Service]
Environment="PATH=/opt/k8s/bin:/bin:/sbin:/usr/bin:/usr/sbin"
EnvironmentFile=-/run/flannel/docker
ExecStart=/opt/k8s/bin/dockerd --log-level=error $DOCKER_NETWORK_OPTIONS
ExecReload=/bin/kill -s HUP $MAINPID
Restart=on-failure
RestartSec=5
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

# 配置国内镜像服务器
cat > docker-daemon.json <<EOF
{
    "registry-mirrors": ["https://hub-mirror.c.163.com", "https://docker.mirrors.ustc.edu.cn"],
    "max-concurrent-downloads": 20
}
EOF


# 拷贝服务文件，镜像服务器到各个节点
source ../00_cluster_env.sh
for ip in ${NODE_IPS[@]}
  do
    echo ">>> ${ip}"
    scp docker.service root@${ip}:/etc/systemd/system/
    ssh root@${ip} "mkdir -p  /etc/docker/"
    scp docker-daemon.json root@${ip}:/etc/docker/daemon.json
  done


# 启动服务
source ../00_cluster_env.sh
for ip in ${NODE_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh root@${ip} "systemctl stop firewalld && systemctl disable firewalld"
    ssh root@${ip} "/usr/sbin/iptables -F && /usr/sbin/iptables -X && /usr/sbin/iptables -F -t nat && /usr/sbin/iptables -X -t nat"
    ssh root@${ip} "/usr/sbin/iptables -P FORWARD ACCEPT"
    ssh root@${ip} "systemctl daemon-reload && systemctl enable docker && systemctl restart docker"
    ssh root@${ip} 'for intf in /sys/devices/virtual/net/docker0/brif/*; do echo 1 > $intf/hairpin_mode; done'
    ssh root@${ip} "sudo sysctl -p /etc/sysctl.d/kubernetes.conf"
  done














