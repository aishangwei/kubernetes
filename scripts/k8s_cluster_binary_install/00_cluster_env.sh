
# Master 节点
MASTER1=192.168.20.141
MASTER2=192.168.20.142
MASTER3=192.168.20.143
MASTER1N="c720141"
MASTER2N="c720142"
MASTER3N="c720143"

# NODE 节点
NODE1=192.168.20.161
NODE2=192.168.20.162
NODE3=192.168.20.163
NODE1N="c720161"
NODE2N="c720162"
NODE3N="c720163"

# ETCD 集群IP
ETCD1=192.168.20.151
ETCD2=192.168.20.152
ETCD3=192.168.20.153
ETCD1N="c720151"
ETCD2N="c720152"
ETCD3N="c720153"

# kube-apiserver 的 VIP（HA 组件 keepalived 发布的 IP）
MASTER_VIP=192.168.20.150

# 所有节点IP
ALL_IPS=($MASTER1 $MASTER2 $MASTER3 $ETCD1 $ETCD2 $ETCD3 $NODE1 $NODE2 $NODE3)

# Master 集群IP
MASTER_IPS=($MASTER1 $MASTER2 $MASTER3)

# Node 集群 IP
NODE_IPS=($NODE1 $NODE2 $NODE3)

# ETCD 集群IP
ETCD_IPS=($ETCD1 $ETCD2 $ETCD3)

# ETCD 集群主机名
ETCD_NAMES=($ETCD1N $ETCD2N $ETCD3N)

# etcd 集群间通信的 IP 和端口
ETCD_NODES="${ETCD1N}=https://${ETCD1}:2380,${ETCD2N}=https://${ETCD2}:2380,${ETCD3N}=https://${ETCD3}:2380"

# etcd 集群服务地址列表
ETCD_ENDPOINTS="https://${ETCD1}:2379,https://${ETCD2}:2379,https://${ETCD3}:2379"

# kube-apiserver VIP 地址（HA 组件 haproxy 监听 8443 端口）
KUBE_APISERVER="https://${MASTER_VIP}:8443"

# kubernetes 服务 IP (一般是 SERVICE_CIDR 中第一个IP)
CLUSTER_KUBERNETES_SVC_IP="10.254.0.1"

# flanneld 网络配置前缀
FLANNEL_ETCD_PREFIX="/kubernetes/network"

# Pod 网段，建议 /16 段地址，部署前路由不可达，部署后集群内路由可达(flanneld 保证)
CLUSTER_CIDR="172.30.0.0/16"

# Haproxy 节点，VIP 所在的网络接口名称
VIP_IF="eth0"

# 生成 EncryptionConfig 所需的加密 key
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

# 服务网段，部署前路由不可达，部署后集群内路由可达(kube-proxy 和 ipvs 保证)
SERVICE_CIDR="10.254.0.0/16"

# 服务端口范围 (NodePort Range)
NODE_PORT_RANGE="8400-9000"

# MASTER 集群主机名
MASTER_NAMES=($MASTER1N $MASTER2N $MASTER3N)



