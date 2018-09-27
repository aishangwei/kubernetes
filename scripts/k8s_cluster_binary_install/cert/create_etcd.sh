#!/bin/bash

source ../00_cluster_env.sh

# 创建证书签名请求
mkdir /root/etcd
cat > /root/etcd/etcd-csr.json <<EOF
{
  "CN": "etcd",
  "hosts": [
    "127.0.0.1",
    "${ETCD1}",
    "${ETCD2}",
    "${ETCD3}"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "k8s",
      "OU": "4Paradigm"
    }
  ]
}
EOF

# 生成证书
cd /root/etcd
cfssl gencert -ca=/etc/kubernetes/cert/ca.pem \
    -ca-key=/etc/kubernetes/cert/ca-key.pem \
    -config=/etc/kubernetes/cert/ca-config.json \
    -profile=kubernetes etcd-csr.json | cfssljson -bare etcd
    
    
# 拷贝证书
mkdir -p /etc/etcd/cert 
cp /root/etcd*.pem /etc/etcd/cert/ && chown -R k8s /etc/etcd/cert 
    
    
    
    
    
    
    
