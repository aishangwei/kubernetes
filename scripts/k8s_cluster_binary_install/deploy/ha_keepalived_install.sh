#!/bin/bash

# 安装 keepalived haproxy
source ../00_cluster_env.sh
for ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh root@${ip} "yum install -y keepalived haproxy"
  done


# 配置 haproxy 
source ../00_cluster_env.sh
cat > haproxy.cfg <<EOF
global
    log /dev/log    local0
    log /dev/log    local1 notice
    chroot /var/lib/haproxy
    stats socket /var/run/haproxy-admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    daemon
    nbproc 1

defaults
    log     global
    timeout connect 5000
    timeout client  10m
    timeout server  10m

listen  admin_stats
    bind 0.0.0.0:10080
    mode http
    log 127.0.0.1 local0 err
    stats refresh 30s
    stats uri /status
    stats realm welcome login\ Haproxy
    stats auth admin:123456
    stats hide-version
    stats admin if TRUE

listen kube-master
    bind 0.0.0.0:8443
    mode tcp
    option tcplog
    balance source
    server ${MASTER1} ${MASTER1}:6443 check inter 2000 fall 2 rise 2 weight 1
    server ${MASTER2} ${MASTER2}:6443 check inter 2000 fall 2 rise 2 weight 1
    server ${MASTER3} ${MASTER3}:6443 check inter 2000 fall 2 rise 2 weight 1
EOF

# 拷贝配置文件 haproxy.cfg 到所有 master节点
source ../00_cluster_env.sh
for ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${ip}"
    scp haproxy.cfg root@${ip}:/etc/haproxy
    ssh root@${ip} "systemctl enable haproxy && systemctl restart haproxy"
  done

# 生成 keepalived master 节点配置
source ../00_cluster_env.sh
cat  > keepalived-master.conf <<EOF
global_defs {
    router_id lb-master-105
}

vrrp_script check-haproxy {
    script "killall -0 haproxy"
    interval 5
    weight -30
}

vrrp_instance VI-kube-master {
    state MASTER
    priority 120
    dont_track_primary
    interface ${VIP_IF}
    virtual_router_id 68
    advert_int 3
    track_script {
        check-haproxy
    }
    virtual_ipaddress {
        ${MASTER_VIP}
    }
}
EOF


# 生成 keepalived backup 节点配置
source ../00_cluster_env.sh
cat  > keepalived-backup.conf <<EOF
global_defs {
    router_id lb-backup-105
}

vrrp_script check-haproxy {
    script "killall -0 haproxy"
    interval 5
    weight -30
}

vrrp_instance VI-kube-master {
    state BACKUP
    priority 110
    dont_track_primary
    interface ${VIP_IF}
    virtual_router_id 68
    advert_int 3
    track_script {
        check-haproxy
    }
    virtual_ipaddress {
        ${MASTER_VIP}
    }
}
EOF

# 拷贝 keepalived master 配置文件
scp keepalived-master.conf root@${MASTER1}:/etc/keepalived/keepalived.conf

# 拷贝 keepalived backup 配置文件
scp keepalived-backup.conf root@${MASTER2}:/etc/keepalived/keepalived.conf
scp keepalived-backup.conf root@${MASTER3}:/etc/keepalived/keepalived.conf


# 启动 keepalived 服务
source ../00_cluster_env.sh
for ip in ${MASTER_IPS[@]}
  do
    echo ">>> ${ip}"
    ssh root@${ip} "systemctl restart keepalived && systemctl enable keepalived"
  done


