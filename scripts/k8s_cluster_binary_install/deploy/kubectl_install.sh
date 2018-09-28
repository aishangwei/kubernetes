#!/bin/bash

wget https://dl.k8s.io/v1.11.3/kubernetes-client-linux-amd64.tar.gz
tar -xzvf kubernetes-client-linux-amd64.tar.gz

# 拷贝 kubectl到本机，用于生成配置文件
cp kubernetes/client/bin/kubectl /opt/k8s/bin/




















