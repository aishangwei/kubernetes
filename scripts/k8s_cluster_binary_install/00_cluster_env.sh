

# kube_apiserver IP，如果有代理，填代理地址
KUBE_APISERVER=182.168.20.151


# ETCD 集群IP
ETCD1=192.168.20.141
ETCD2=192.168.20.142
ETCD3=192.168.20.143
ETCD1N="c720141"
ETCD2N="c720142"
ETCD3N="c720143"

# etcd 集群服务地址列表
ETCD_ENDPOINTS="https://${ETCD1}:2379,https://${ETCD2}:2379,https://${ETCD3}:2379"


# flanneld 网络配置前缀
FLANNEL_ETCD_PREFIX="/kubernetes/network"

# Pod 网段，建议 /16 段地址，部署前路由不可达，部署后集群内路由可达(flanneld 保证)
CLUSTER_CIDR="172.30.0.0/16"














