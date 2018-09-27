#!/bin/bash

source ./00_cluster_env.sh

# 创建证书签名请求
mkdir /root/flanneld
cat > /root/flanneld/flanneld-csr.json <<EOF
{
  "CN": "flanneld",
  "hosts": [],
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


# 生成证书和私钥
cd /root/flanneld/
cfssl gencert -ca=/etc/kubernetes/cert/ca.pem \
  -ca-key=/etc/kubernetes/cert/ca-key.pem \
  -config=/etc/kubernetes/cert/ca-config.json \
  -profile=kubernetes flanneld-csr.json | cfssljson -bare flanneld   
 
 
# 拷贝证书和私钥到所有节点（master 和 worker）
cd /root/flanneld
cp flanneld*.pem  /etc/flanneld/cert/
  
  
  
  
