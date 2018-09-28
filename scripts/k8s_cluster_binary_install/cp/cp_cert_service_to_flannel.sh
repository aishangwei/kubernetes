#!/bin/bash


# 拷贝flanneld到全部节点
source ../00_cluster_env.sh
for ip in ${ALL_IPS[@]}
  do
    echo ">>> ${ip}"
    scp  ../deploy/flannel/{flanneld,mk-docker-opts.sh} k8s@${ip}:/opt/k8s/bin/
    ssh k8s@${node_ip} "chmod +x /opt/k8s/bin/*"
  done

# 拷贝 flanneld 启动脚本到所有节点
source ../00_cluster_env.sh
for ip in ${ALL_IPS[@]}
  do
    echo ">>> ${ip}"
    scp ../deploy/flanneld.service root@${ip}:/etc/systemd/system/
  done

# 拷贝证书和私钥到所有节点
source ../00_cluster_env.sh
for ip in ${ALL_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh root@${ip} "mkdir -p /etc/flanneld/cert && chown -R k8s /etc/flanneld"
    scp ~/flanneld/flanneld*.pem k8s@${ip}:/etc/flanneld/cert
    scp ~/ca/ca.pem   k8s@${ip}:/etc/kubernetes/cert/
  done


# 向 etcd 写入集群POD网段信息,只需要执行一次，手工执行一次
source ../00_cluster_env.sh
#etcdctl \
#  --endpoints=${ETCD_ENDPOINTS} \
#  --ca-file=/etc/kubernetes/cert/ca.pem \
#  --cert-file=/etc/flanneld/cert/flanneld.pem \
#  --key-file=/etc/flanneld/cert/flanneld-key.pem \
#  set ${FLANNEL_ETCD_PREFIX}/config '{"Network":"'${CLUSTER_CIDR}'", "SubnetLen": 24, "Backend": {"Type": "vxlan"}}'



# 启动 flanneld 服务
source ../00_cluster_env.sh
for ip in ${ALL_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh root@${node_ip} "systemctl daemon-reload && systemctl enable flanneld && systemctl restart flanneld"
  done




