#!/bin/bash

# 拷贝 etcd 命令到 所有 etcd 节点
source ../00_cluster_env.sh
for ip in ${ETCD_IPS[@]}
  do
    echo ">>> ${ip}"
    scp ../deploy/etcd-v3.3.9-linux-amd64/etcd* k8s@${ip}:/opt/k8s/bin
    ssh k8s@${ip} "chmod +x /opt/k8s/bin/*"
  done


# 修改启动服务文件  systemd
source ../00_cluster_env.sh
for (( i=0; i < 3; i++ ))
  do
    sed -e "s/##ETCD_NAME##/${ETCD_NAMES[i]}/" -e "s/##ETCD_IP##/${ETCD_IPS[i]}/" ../deploy/etcd.service.template > ../deploy/etcd-${ETCD_IPS[i]}.service 
  done


# 拷贝启动服务文件  systemd
source ../00_cluster_env.sh
for ip in ${ETCD_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh root@${ip} "mkdir -p /var/lib/etcd && chown -R k8s /var/lib/etcd" 
    scp ../deploy/etcd-${ip}.service root@${ip}:/etc/systemd/system/etcd.service
  done


# 拷贝证书和私钥
source ../00_cluster_env.sh
for ip in ${ETCD_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh root@${ip} "mkdir -p /etc/etcd/cert && chown -R k8s /etc/etcd/cert"
    scp ~/etcd/etcd*.pem k8s@${ip}:/etc/etcd/cert/
    scp ~/ca/ca.pem   k8s@${ip}:/etc/kubernetes/cert/
  done


# 启动 etcd 服务
source ../00_cluster_env.sh
for ip in ${ETCD_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh root@${ip} "systemctl daemon-reload && systemctl enable etcd && systemctl restart etcd &"
  done






