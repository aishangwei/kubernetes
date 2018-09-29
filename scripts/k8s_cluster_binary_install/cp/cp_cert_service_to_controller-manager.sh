#!/bin/bash

source ../00_cluster_env.sh
for ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${ip}"
    scp ~/kube-controller-manager/kube-controller-manager*.pem k8s@${ip}:/etc/kubernetes/cert/
    scp ~/kube-controller-manager/kube-controller-manager.kubeconfig k8s@${ip}:/etc/kubernetes/
    scp ../deploy/kube-controller-manager.service root@${ip}:/etc/systemd/system/
    ssh root@${ip} "mkdir -p /var/log/kubernetes && chown -R k8s /var/log/kubernetes"
    ssh root@${ip} "systemctl daemon-reload && systemctl enable kube-controller-manager && systemctl restart kube-controller-manager"
  done

























