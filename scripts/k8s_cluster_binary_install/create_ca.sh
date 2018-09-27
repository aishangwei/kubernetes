
source ./00_cluster_env.sh



########################################## 安装 cfssl 工具集 ###################
sudo mkdir -p /opt/k8s/cert && sudo chown -R k8s /opt/k8s && cd /opt/k8s
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
mv cfssl_linux-amd64 /opt/k8s/bin/cfssl

wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
mv cfssljson_linux-amd64 /opt/k8s/bin/cfssljson

wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
mv cfssl-certinfo_linux-amd64 /opt/k8s/bin/cfssl-certinfo

chmod +x /opt/k8s/bin/*
export PATH=/opt/k8s/bin:$PATH

########################### 安装 cfssl 工具集 结束 ########################################



##################################### 创建 CA ###############################
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
cd /root/ca/ && cfssl gencert -initca ca-csr.json | cfssljson -bare ca

# 拷贝文件
cp /root/ca/ca*.pem /root/ca/ca-config.json  /etc/kubernetes/cert && chown k8s /etc/kubernetes/cert

################################### 创建 CA 结束 ############################################



################################## 创建 admin 证书和私钥 #####################################

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

################################## 创建 admin 证书和私钥  结束 #####################################




################## 创建 Etcd 证书 ######################################

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
      
 ################################ 创建 Etcd 证书 结束 #######################################
    

################################## 创建 Flannel 证书和密钥 ######################################

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

cd /root/flanneld/
cfssl gencert -ca=/etc/kubernetes/cert/ca.pem \
  -ca-key=/etc/kubernetes/cert/ca-key.pem \
  -config=/etc/kubernetes/cert/ca-config.json \
  -profile=kubernetes flanneld-csr.json | cfssljson -bare flanneld   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
