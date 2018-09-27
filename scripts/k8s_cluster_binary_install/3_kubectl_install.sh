#!/bin/bash

# 安装 kubectl
#tar -xzvf ./software/kubernetes-client-linux-amd64.tar.gz 
#cp kubectl /opt/k8s/bin/ && chmod +x /opt/k8s/bin/* && chown -R k8s /opt/k8s/bin

source ./0_cluster_env.sh

# 创建 admin 证书和私钥
mkdir -p /root/kubectl && cd /root/kubectl
cat > /root/kubectl/admin-csr.json <<EOF
{
  "CN": "admin",
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
      "O": "system:masters",
      "OU": "4Paradigm"
    }
  ]
}
EOF

# 生成证书和私钥
cfssl gencert -ca=/etc/kubernetes/cert/ca.pem \
  -ca-key=/etc/kubernetes/cert/ca-key.pem \
  -config=/etc/kubernetes/cert/ca-config.json \
  -profile=kubernetes admin-csr.json | cfssljson -bare admin


# 创建 kubeconfig 文件

# 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/cert/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=kubectl.kubeconfig
  
 # 设置客户端认证参数
 kubectl config set-credentials admin \
  --client-certificate=admin.pem \
  --client-key=admin-key.pem \
  --embed-certs=true \
  --kubeconfig=kubectl.kubeconfig
  
 # 设置上下文参数
kubectl config set-context kubernetes \
  --cluster=kubernetes \
  --user=admin \
  --kubeconfig=kubectl.kubeconfig
  
 # 设置默认上下文
 kubectl config use-context kubernetes --kubeconfig=kubectl.kubeconfig
  
  
 # 拷贝 kubeconfig 配置文件
 mkdir -p ~/.kube
 mv /root/kubectl/kubectl.kubeconfig ~/.kube/
  
