#! /bin/bash

# system updates and minimal toolset installation
yum clean all
yum -y update all
yum -y install nc expect ed ntp dmidecode pciutils wget

# start ntpd
systemctl start ntpd
systemctl enable ntpd

# disable the firewall
systemctl stop firewalld
systemctl disable firewalld

# disable IPV6 and set swappiness to 1
grep net.ipv6.conf.all.disable_ipv6 /etc/sysctl.conf || (echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf)
grep net.ipv6.conf.default.disable_ipv6 /etc/sysctl.conf || (echo "net.ipv6.conf.default.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf)
grep net.ipv6.conf.lo.disable_ipv6 /etc/sysctl.conf || (echo "net.ipv6.conf.lo.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf)
grep vm.swappiness /etc/sysctl.conf || (echo "vm.swappiness = 1" | sudo tee -a /etc/sysctl.conf)
sysctl -p

# setup required system parameters
echo "umask 022" >> /etc/profile
echo "echo 'never' > /sys/kernel/mm/redhat_transparent_hugepage/defrag" >> /etc/rc.local
echo "echo 'never' > /sys/kernel/mm/redhat_transparent_hugepage/enabled" >> /etc/rc.local
sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/sysconfig/selinux
sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config
setenforce 0

# set ambari authorized key
mkdir ~/.ssh
cp /vagrant/rsa/id_rsa_hdp.pub ~/.ssh/id_rsa.pub
cp /vagrant/rsa/id_rsa_hdp ~/.ssh/id_rsa
cat /vagrant/rsa/id_rsa_hdp.pub >> ~/.ssh/authorized_keys

# remove hostname entry from 127.0.0.1
sed -i "1d" /etc/hosts
