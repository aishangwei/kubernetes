# 版本信息
K8S_VERSION=v1.11.2
ETCD_VERSION=3.2.18
PAUSE_VERSION=3.1
COREDNS_VERSION=1.1.3

DEFAULTBACKEND_VERSION=1.4
DASHBOARD_VERSION=v1.10.0
HEAPSTER_GRAFANA_VERSION=v5.0.4
HEAPSTER_VERSION=v1.5.4
HEAPSTER_INFLUXDB_VERSION=v1.5.2
HELM_TILLER_VERSION=v2.9.1
METRICS_VERSION=v0.2.1


############ 拉取镜像
docker pull anjia0532/google-containers.kube-apiserver-amd64:${K8S_VERSION}
docker pull anjia0532/google-containers.kube-controller-manager-amd64:${K8S_VERSION}
docker pull anjia0532/google-containers.kube-scheduler-amd64:${K8S_VERSION}
docker pull anjia0532/google-containers.kube-proxy-amd64:${K8S_VERSION}
docker pull anjia0532/google-containers.pause:${PAUSE_VERSION}
docker pull anjia0532/google-containers.etcd-amd64:${ETCD_VERSION}
docker pull anjia0532/google-containers.coredns:${COREDNS_VERSION}

#docker pull anjia0532/google-containers.defaultbackend:${DEFAULTBACKEND_VERSION}
#docker pull anjia0532/google-containers.kubernetes-dashboard-amd64:${DASHBOARD_VERSION}
#docker pull anjia0532/google-containers.heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION}
#docker pull anjia0532/google-containers.heapster-amd64:${HEAPSTER_VERSION}
#docker pull anjia0532/google-containers.heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION}
#docker pull anjia0532/kubernetes-helm.tiller:${HELM_TILLER_VERSION} 
#docker pull anjia0532/metrics-server-amd64:${METRICS_VERSION}

############### 修改tag
docker tag anjia0532/google-containers.kube-apiserver-amd64:${K8S_VERSION}  k8s.gcr.io/kube-apiserver-amd64:${K8S_VERSION}
docker tag anjia0532/google-containers.kube-controller-manager-amd64:${K8S_VERSION}  k8s.gcr.io/kube-controller-manager-amd64:${K8S_VERSION}
docker tag anjia0532/google-containers.kube-scheduler-amd64:${K8S_VERSION}  k8s.gcr.io/kube-scheduler-amd64:${K8S_VERSION}
docker tag anjia0532/google-containers.kube-proxy-amd64:${K8S_VERSION}   k8s.gcr.io/kube-proxy-amd64:${K8S_VERSION}
docker tag anjia0532/google-containers.pause:${PAUSE_VERSION}   k8s.gcr.io/pause:${PAUSE_VERSION}
docker tag anjia0532/google-containers.etcd-amd64:${ETCD_VERSION}   k8s.gcr.io/etcd-amd64:${ETCD_VERSION}
docker tag anjia0532/google-containers.coredns:${COREDNS_VERSION}   k8s.gcr.io/coredns:${COREDNS_VERSION}

#docker tag anjia0532/google-containers.defaultbackend:${DEFAULTBACKEND_VERSION}  gcr.io/google_containers/defaultbackend:${DEFAULTBACKEND_VERSION}
#docker tag anjia0532/google-containers.kubernetes-dashboard-amd64:${DASHBOARD_VERSION}  k8s.gcr.io/kubernetes-dashboard-amd64:${DASHBOARD_VERSION}
#docker tag anjia0532/google-containers.heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION} k8s.gcr.io/heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION}
#docker tag anjia0532/google-containers.heapster-amd64:${HEAPSTER_VERSION}  k8s.gcr.io/heapster-amd64:${HEAPSTER_VERSION}
#docker tag anjia0532/google-containers.heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION} k8s.gcr.io/heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION}
#docker tag anjia0532/kubernetes-helm.tiller:${HELM_TILLER_VERSION}  gcr.io/kubernetes-helm/tiller:${HELM_TILLER_VERSION}
#docker tag anjia0532/metrics-server-amd64:${METRICS_VERSION}   k8s.gcr.io/metrics-server-amd64:${METRICS_VERSION}

############### 删除镜像
docker rmi anjia0532/google-containers.kube-apiserver-amd64:${K8S_VERSION}
docker rmi anjia0532/google-containers.kube-controller-manager-amd64:${K8S_VERSION}
docker rmi anjia0532/google-containers.kube-scheduler-amd64:${K8S_VERSION}
docker rmi anjia0532/google-containers.kube-proxy-amd64:${K8S_VERSION}
docker rmi anjia0532/google-containers.pause:${PAUSE_VERSION}
docker rmi anjia0532/google-containers.etcd-amd64:${ETCD_VERSION}
docker rmi anjia0532/google-containers.coredns:${COREDNS_VERSION}

#docker rmi anjia0532/google-containers.defaultbackend:${DEFAULTBACKEND_VERSION}
#docker rmi anjia0532/google-containers.kubernetes-dashboard-amd64:${DASHBOARD_VERSION}
#docker rmi anjia0532/google-containers.heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION}
#docker rmi anjia0532/google-containers.heapster-amd64:${HEAPSTER_VERSION}
#docker rmi anjia0532/google-containers.heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION}
#docker rmi anjia0532/kubernetes-helm.tiller:${HELM_TILLER_VERSION}
#docker rmi anjia0532/metrics-server-amd64:${METRICS_VERSION}
