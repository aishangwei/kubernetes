#!/bin/bash

# 拷贝证书和私钥文件,加密文件，服务文件，启动服务
source ../00_cluster_env.sh
for ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh root@${ip} "mkdir -p /etc/kubernetes/cert/ && sudo chown -R k8s /etc/kubernetes/cert/"
    scp ~/kube-apiserver/kubernetes*.pem k8s@${ip}:/etc/kubernetes/cert/
    scp ../deploy/encryption-config.yaml root@${ip}:/etc/kubernetes/
    ssh root@${ip} "mkdir -p /var/log/kubernetes && chown -R k8s /var/log/kubernetes"
    scp ../deploy/kube-apiserver-${ip}.service root@${ip}:/etc/systemd/system/kube-apiserver.service
    ssh root@${ip} "systemctl daemon-reload && systemctl enable kube-apiserver && systemctl restart kube-apiserver"
  done




















