#!/bin/bash

source ../00_cluster_env.sh

# 创建证书签名请求
mkdir /root/kube-controller-manager
cat > /root/kube-controller-manager/kube-controller-manager-csr.json <<EOF
{
    "CN": "system:kube-controller-manager",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "hosts": [
      "127.0.0.1",
      "${MASTER1}",
      "${MASTER2}",
      "${MASTER3}"
    ],
    "names": [
      {
        "C": "CN",
        "ST": "BeiJing",
        "L": "BeiJing",
        "O": "system:kube-controller-manager",
        "OU": "4Paradigm"
      }
    ]
}
EOF


# 生成证书和私钥
cd /root/kube-controller-manager
cfssl gencert -ca=/etc/kubernetes/cert/ca.pem \
  -ca-key=/etc/kubernetes/cert/ca-key.pem \
  -config=/etc/kubernetes/cert/ca-config.json \
  -profile=kubernetes kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager


# 将生成的证书和私钥拷贝到所有master 节点
cp /root/kube-controller-manager*.pem /etc/kubernetes/cert/
chown -R k8s /etc/kubernetes/cert


# 创建 kubeconfig 文件
cd /root/kube-controller-manager/
kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/cert/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=kube-controller-manager.pem \
  --client-key=kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-context system:kube-controller-manager \
  --cluster=kubernetes \
  --user=system:kube-controller-manager \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config use-context system:kube-controller-manager --kubeconfig=kube-controller-manager.kubeconfig


# 拷贝 kubeconfig 文件到所有 master 节点
cp kube-controller-manager.kubeconfig /etc/kubernetes/
chown -R k8s /etc/kubernetes







