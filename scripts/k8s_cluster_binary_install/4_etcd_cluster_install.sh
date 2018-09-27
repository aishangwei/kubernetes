#!/bin/bash

###### 全局变量，根据自己的需要修改

# ETCD 集群IP
ETCD1=192.168.20.141
ETCD2=192.168.20.142
ETCD3=192.168.20.143
ETCD1N="c720141"
ETCD2N="c720142"
ETCD3N="c720143"

# 本机ETCD IP
LOCAL_HOST=192.168.20.141
LOCAL_HOSTNAME=c729141

#######


# 安装 etcd
wget https://github.com/coreos/etcd/releases/download/v3.3.9/etcd-v3.3.9-linux-amd64.tar.gz
tar -xvf etcd-v3.3.9-linux-amd64.tar.gz

cp etcd-v3.3.9-linux-amd64/etcd* /opt/k8s/bin 
chown -R /opt/k8s/bin/ && chmod +x /opt/k8s/bin/*

cat > etcd.service.template <<EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos

[Service]
User=k8s
Type=notify
WorkingDirectory=/var/lib/etcd/
ExecStart=/opt/k8s/bin/etcd \\
  --data-dir=/var/lib/etcd \\
  --name=${LOCAL_HOSTNAME} \\
  --cert-file=/etc/etcd/cert/etcd.pem \\
  --key-file=/etc/etcd/cert/etcd-key.pem \\
  --trusted-ca-file=/etc/kubernetes/cert/ca.pem \\
  --peer-cert-file=/etc/etcd/cert/etcd.pem \\
  --peer-key-file=/etc/etcd/cert/etcd-key.pem \\
  --peer-trusted-ca-file=/etc/kubernetes/cert/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --listen-peer-urls=https://${LOCAL_HOST}:2380 \\
  --initial-advertise-peer-urls=https://${LOCAL_HOST}:2380 \\
  --listen-client-urls=https://${LOCAL_HOST}:2379,http://127.0.0.1:2379 \\
  --advertise-client-urls=https://${LOCAL_HOST}:2379 \\
  --initial-cluster-token=etcd-cluster-0 \\
  --initial-cluster="${ETCD1N}=https://${ETCD1}:2380,${ETCD2N}=https://${ETCD2}:2380,${ETCD3N}=https://${ETCD3}:2380" \\
  --initial-cluster-state=new
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF


# 拷贝证书
mkdir -p /etc/etcd/cert 
cp /root/etcd*.pem /etc/etcd/cert && chown -R k8s /etc/etcd/cert















