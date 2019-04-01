#!/bin/bash

################# 系统环境配置 #####################

# 关闭 Selinux/firewalld
systemctl stop firewalld && systemctl disable firewalld
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# 关闭交换分区
swapoff -a
cp /etc/{fstab,fstab.bak}
cat /etc/fstab.bak | grep -v swap > /etc/fstab

# 设置 iptables
echo """
vm.swappiness = 0
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
""" > /etc/sysctl.conf
modprobe br_netfilter
sysctl -p

# 同步时间
yum install -y ntpdate
ntpdate -u ntp.api.bz

# 升级内核
# wget https://elrepo.org/linux/kernel/el7/x86_64/RPMS/kernel-ml-5.0.4-1.el7.elrepo.x86_64.rpm
# wget https://elrepo.org/linux/kernel/el7/x86_64/RPMS/kernel-ml-devel-5.0.4-1.el7.elrepo.x86_64.rpm
yum -y install /tmp/kernel-ml-5.0.4-1.el7.elrepo.x86_64.rpm /tmp/kernel-ml-devel-5.0.4-1.el7.elrepo.x86_64.rpm

# 调整默认内核启动
#cat /boot/grub2/grub.cfg |grep menuentry
grub2-set-default "CentOS Linux (5.0.4-1.el7.elrepo.x86_64) 7 (Core)"

# 检查是否修改正确
#grub2-editenv list
reboot
