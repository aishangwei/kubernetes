#!/bin/bash

source ./0_cluster_env.sh

# 安装 cfssl 工具集
sudo mkdir -p /opt/k8s/cert && sudo chown -R k8s /opt/k8s && cd /opt/k8s
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
mv cfssl_linux-amd64 /opt/k8s/bin/cfssl

wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
mv cfssljson_linux-amd64 /opt/k8s/bin/cfssljson

wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
mv cfssl-certinfo_linux-amd64 /opt/k8s/bin/cfssl-certinfo

chmod +x /opt/k8s/bin/*
export PATH=/opt/k8s/bin:$PATH

# 创建ca存放文件目录
mkdir /root/ca

# 创建根证书配置文件
cat > /root/ca/ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "87600h"
      }
    }
  }
}
EOF

# 创建 证书签名请求文件
cat > /root/ca/ca-csr.json <<EOF
{
  "CN": "kubernetes",
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

# 生成CA证书和私钥
cd /root/ca/ && ccfssl gencert -initca ca-csr.json | cfssljson -bare ca

# 拷贝文件
cp /root/ca/ca*.pem /root/ca/ca-config.json  /etc/kubernetes/cert && chown k8s /etc/kubernetes/cert






