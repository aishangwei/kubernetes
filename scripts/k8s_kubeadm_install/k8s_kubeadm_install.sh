#!/bin/bash

# 全局变量，根据您的实际情况修改
HOST1=192.168.20.141
HOST2=192.168.20.142
HOST3=192.168.20.143
HOST1N="c720141"
HOST2N="c720142"
HOST3N="c720143"

cat >> /etc/hosts <<EOF
$HOST1  $HOST1N
$HOST2  $HOST2N
$HOST3  $HOST3N
EOF


yum -y install wget


# 关闭selinux,firewall,swap
setenforce 0 && sed -i "/^SELINUX/s/enforcing/disabled/" /etc/selinux/config
systemctl stop firewalld && systemctl disable firewalld
swapoff -a && sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
modprobe br_netfilter  && modprobe ip_vs


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


# 设置系统时区
sudo timedatectl set-timezone Asia/Shanghai
sudo timedatectl set-local-rtc 0
sudo systemctl restart rsyslog
sudo systemctl restart crond


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


# 版本信息
K8S_VERSION=v1.11.2
ETCD_VERSION=3.2.18
PAUSE_VERSION=3.1
COREDNS_VERSION=1.1.3

DEFAULTBACKEND_VERSION=1.4
DASHBOARD_VERSION=v1.10.0
HEAPSTER_GRAFANA_VERSION=v5.0.4
HEAPSTER_VERSION=v1.5.4
HEAPSTER_INFLUXDB_VERSION=v1.5.2
HELM_TILLER_VERSION=v2.9.1

############ 拉取镜像
docker pull anjia0532/google-containers.kube-apiserver-amd64:${K8S_VERSION}
docker pull anjia0532/google-containers.kube-controller-manager-amd64:${K8S_VERSION}
docker pull anjia0532/google-containers.kube-scheduler-amd64:${K8S_VERSION}
docker pull anjia0532/google-containers.kube-proxy-amd64:${K8S_VERSION}
docker pull anjia0532/google-containers.pause:${PAUSE_VERSION}
docker pull anjia0532/google-containers.etcd-amd64:${ETCD_VERSION}
docker pull anjia0532/google-containers.coredns:${COREDNS_VERSION}

#docker pull anjia0532/google-containers.defaultbackend:${DEFAULTBACKEND_VERSION}
#docker pull anjia0532/google-containers.kubernetes-dashboard-amd64:${DASHBOARD_VERSION}
#docker pull anjia0532/google-containers.heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION}
#docker pull anjia0532/google-containers.heapster-amd64:${HEAPSTER_VERSION}
#docker pull anjia0532/google-containers.heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION}
#docker pull  anjia0532/kubernetes-helm.tiller:${HELM_TILLER_VERSION} 

############### 修改tag
docker tag anjia0532/google-containers.kube-apiserver-amd64:${K8S_VERSION}  k8s.gcr.io/kube-apiserver-amd64:${K8S_VERSION}
docker tag anjia0532/google-containers.kube-controller-manager-amd64:${K8S_VERSION}  k8s.gcr.io/kube-controller-manager-amd64:${K8S_VERSION}
docker tag anjia0532/google-containers.kube-scheduler-amd64:${K8S_VERSION}  k8s.gcr.io/kube-scheduler-amd64:${K8S_VERSION}
docker tag anjia0532/google-containers.kube-proxy-amd64:${K8S_VERSION}   k8s.gcr.io/kube-proxy-amd64:${K8S_VERSION}
docker tag anjia0532/google-containers.pause:${PAUSE_VERSION}   k8s.gcr.io/pause:${PAUSE_VERSION}
docker tag anjia0532/google-containers.etcd-amd64:${ETCD_VERSION}   k8s.gcr.io/etcd-amd64:${ETCD_VERSION}
docker tag anjia0532/google-containers.coredns:${COREDNS_VERSION}   k8s.gcr.io/coredns:${COREDNS_VERSION}

#docker tag anjia0532/google-containers.defaultbackend:${DEFAULTBACKEND_VERSION}  gcr.io/google_containers/defaultbackend:${DEFAULTBACKEND_VERSION}
#docker tag anjia0532/google-containers.kubernetes-dashboard-amd64:${DASHBOARD_VERSION}  k8s.gcr.io/kubernetes-dashboard-amd64:${DASHBOARD_VERSION}
#docker tag anjia0532/google-containers.heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION} k8s.gcr.io/heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION}
#docker tag anjia0532/google-containers.heapster-amd64:${HEAPSTER_VERSION}  k8s.gcr.io/heapster-amd64:${HEAPSTER_VERSION}
#docker tag anjia0532/google-containers.heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION} k8s.gcr.io/heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION}
#docker tag anjia0532/kubernetes-helm.tiller:${HELM_TILLER_VERSION}  gcr.io/kubernetes-helm/tiller:${HELM_TILLER_VERSION}

############### 删除镜像
docker rmi anjia0532/google-containers.kube-apiserver-amd64:${K8S_VERSION}
docker rmi anjia0532/google-containers.kube-controller-manager-amd64:${K8S_VERSION}
docker rmi anjia0532/google-containers.kube-scheduler-amd64:${K8S_VERSION}
docker rmi anjia0532/google-containers.kube-proxy-amd64:${K8S_VERSION}
docker rmi anjia0532/google-containers.pause:${PAUSE_VERSION}
docker rmi anjia0532/google-containers.etcd-amd64:${ETCD_VERSION}
docker rmi anjia0532/google-containers.coredns:${COREDNS_VERSION}

#docker rmi anjia0532/google-containers.defaultbackend:${DEFAULTBACKEND_VERSION}
#docker rmi anjia0532/google-containers.kubernetes-dashboard-amd64:${DASHBOARD_VERSION}
#docker rmi anjia0532/google-containers.heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION}
#docker rmi anjia0532/google-containers.heapster-amd64:${HEAPSTER_VERSION}
#docker rmi anjia0532/google-containers.heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION}
#docker rmi anjia0532/kubernetes-helm.tiller:${HELM_TILLER_VERSION}






