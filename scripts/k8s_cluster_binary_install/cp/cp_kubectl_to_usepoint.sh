#!/bin/bash



#拷贝 kubectl 命令到使用节点
source ../00_cluster_env.sh
for ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${ip}"
    scp ../deploy/kubernetes/client/bin/kubectl k8s@${ip}:/opt/k8s/bin/
    ssh k8s@${ip} "chmod +x /opt/k8s/bin/*"
  done


# 拷贝 kubeconfig 文件到 家目录
source ../00_cluster_env.sh
for ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh k8s@${ip} "mkdir -p ~/.kube"
    scp ~/kubectl/kubectl.kubeconfig k8s@${ip}:~/.kube/config
    ssh root@${ip} "mkdir -p ~/.kube"
    scp ~/kubectl/kubectl.kubeconfig root@${ip}:~/.kube/config
  done










