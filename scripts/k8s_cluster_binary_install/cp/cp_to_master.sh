#!/bin/bash

source ../00_cluster_env.sh

# 拷贝到所有 master 节点
for ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh root@${ip} "mkdir -p /etc/kubernetes/cert && chown -R k8s /etc/kubernetes"
    scp ca*.pem ca-config.json k8s@${ip}:/etc/kubernetes/cert
  done
  
