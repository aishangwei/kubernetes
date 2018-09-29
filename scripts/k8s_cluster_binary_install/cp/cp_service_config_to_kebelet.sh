#!/bin/bash

#拷贝 kubelet-bootstarp 配置文件
source ../00_cluster_env.sh
for node_name in ${NODE_NAMES[@]}
  do
    echo ">>> ${node_name}"
    scp ../cert/kubelet-bootstrap-${node_name}.kubeconfig k8s@${node_name}:/etc/kubernetes/kubelet-bootstrap.kubeconfig
  done

# 拷贝 kubelet 配置参数到全部 node 节点
source ../00_cluster_env.sh
for node_ip in ${NODE_IPS[@]}
  do 
    echo ">>> ${node_ip}"
    sed -e "s/##NODE_IP##/${node_ip}/" ../deploy/kubelet.config.json.template > ../deploy/kubelet.config-${node_ip}.json
    scp ../deploy/kubelet.config-${node_ip}.json root@${node_ip}:/etc/kubernetes/kubelet.config.json
  done


# 拷贝 kubelet 服务文件
source ../00_cluster_env.sh
for node_name in ${NODE_NAMES[@]}
  do 
    echo ">>> ${node_name}"
    sed -e "s/##NODE_NAME##/${node_name}/" ../deploy/kubelet.service.template > ../deploy/kubelet-${node_name}.service
    scp ../deploy/kubelet-${node_name}.service root@${node_name}:/etc/systemd/system/kubelet.service
  done


# Bootstarp Token Auth 和授予权限
kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --group=system:bootstrappers








