#!/bin/bash

source ../00_cluster_env.sh
for ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${ip}"
    scp ~/kube-scheduler/kube-scheduler.kubeconfig k8s@${ip}:/etc/kubernetes/
    scp ../deploy/kube-scheduler.service root@${ip}:/etc/systemd/system/
    ssh root@${ip} "mkdir -p /var/log/kubernetes && chown -R k8s /var/log/kubernetes"
    ssh root@${ip} "systemctl daemon-reload && systemctl enable kube-scheduler && systemctl restart kube-scheduler"
  done











