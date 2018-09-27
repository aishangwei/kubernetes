#!/bin/bash

source ./0_cluster_env.sh

# 主机名解析
cat >> /etc/hosts <<EOF
$HOST1    $HOST1N
$HOST2    $HOST2N
$HOST3    $HOST3N
EOF

# 关闭SELINUX
setenforce 0 && sed -i "/^SELINUX/s/enforcing/disabled/" /etc/selinux/config

# 关闭firewall
sudo systemctl stop firewalld && systemctl disable firewalld
sudo iptables -F && sudo iptables -X && sudo iptables -F -t nat && sudo iptables -X -t nat
sudo iptables -P FORWARD ACCEPT

# 关闭 Swap 分区
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# 关闭 dnsmasq
sudo service dnsmasq stop && systemctl disable dnsmasq

# 加载内核模块
sudo modprobe br_netfilter  && modprobe ip_vs

# 设置系统参数
cat > /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
vm.swappiness=0
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_watches=89100
EOF
sudo sysctl -p /etc/sysctl.d/kubernetes.conf
sudo mount -t cgroup -o cpu,cpuacct none /sys/fs/cgroup/cpu,cpuacct

# 设置系统时区
sudo timedatectl set-timezone Asia/Shanghai
sudo timedatectl set-local-rtc 0
sudo systemctl restart rsyslog
sudo systemctl restart crond

# 添加 k8s和docker用户
sudo useradd -m k8s
sudo sh -c 'echo 123456 | passwd k8s --stdin'
#sudo visduo
#sudo grep '%wheel.*NOPASSWD: ALL' /etc/sudoers
#%wheel    ALL=(ALL)    NOPASSWD: ALL
#%wheel    ALL=(ALL)    NOPASSWD: ALL

sudo useradd -m docker
sudo gpasswd -a k8s docker
sudo mkdir -p /etc/docker

# 创建目录
sudo mkdir -p /opt/k8s/bin && sudo chown -R k8s /opt/k8s
sudo sudo mkdir -p /etc/kubernetes/cert && sudo chown -R k8s /etc/kubernetes
sudo mkdir -p /etc/etcd/cert && sudo chown -R k8s /etc/etcd/cert
sudo mkdir -p /var/lib/etcd && chown -R k8s /var/lib/etcd


# 设置镜像
cat > /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": ["https://hub-mirror.c.163.com", "https://docker.mirrors.ustc.edu.cn"],
    "max-concurrent-downloads": 20
}
EOF

echo 'PATH=/opt/k8s/bin:\$PATH' > /etc/profile.d/k8s.sh

# 安装依赖软件
sudo  yum install -y epel-release
sudo yum install -y conntrack ipvsadm ipset jq sysstat curl iptables libseccomp

