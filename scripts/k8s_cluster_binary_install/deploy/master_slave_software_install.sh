#!/bin/bash

source ../00_cluster_env.sh
wget https://dl.k8s.io/v1.11.3/kubernetes-server-linux-amd64.tar.gz
tar -xzvf kubernetes-server-linux-amd64.tar.gz
cd kubernetes
tar -xzvf  kubernetes-src.tar.gz

for ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${ip}"
    scp server/bin/* k8s@${ip}:/opt/k8s/bin/
    ssh k8s@${ip} "chmod +x /opt/k8s/bin/*"
  done


for ip in ${NODE_IPS[@]}
  do
    echo ">>> ${ip}"
    scp server/bin/kubelet server/bin/kube-proxy* k8s@${ip}:/opt/k8s/bin/
    ssh k8s@${ip} "chmod +x /opt/k8s/bin/*"
  done













