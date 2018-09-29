#!/bin/bash


# 拷贝 kubeconfig 文件到全部的 node 节点
source ../00_cluster_env.sh
for node_name in ${NODE_NAMES[@]}
  do
    echo ">>> ${node_name}"
    scp ~/kube-proxy/kube-proxy.kubeconfig k8s@${node_name}:/etc/kubernetes/
  done


# 拷贝 kube-proxy 配置到所有的 node 节点
source ../00_cluster_env.sh
for (( i=0; i < 3; i++ ))
  do 
    echo ">>> ${NODE_NAMES[i]}"
    sed -e "s/##NODE_NAME##/${NODE_NAMES[i]}/" -e "s/##NODE_IP##/${NODE_IPS[i]}/" ../deploy/kube-proxy.config.yaml.template > ../deploy/kube-proxy-${NODE_NAMES[i]}.config.yaml
    scp ../deploy/kube-proxy-${NODE_NAMES[i]}.config.yaml root@${NODE_NAMES[i]}:/etc/kubernetes/kube-proxy.config.yaml
  done


# 拷贝服务文件到所有的Node节点
source ../00_cluster_env.sh
for node_name in ${NODE_NAMES[@]}
  do 
    echo ">>> ${node_name}"
    scp ../deploy/kube-proxy.service root@${node_name}:/etc/systemd/system/
  done


# 启动 kube-proxy 服务
source ../00_cluster_env.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "mkdir -p /var/lib/kube-proxy"
    ssh root@${node_ip} "mkdir -p /var/log/kubernetes && chown -R k8s /var/log/kubernetes"
    ssh root@${node_ip} "systemctl daemon-reload && systemctl enable kube-proxy && systemctl restart kube-proxy"
  done













