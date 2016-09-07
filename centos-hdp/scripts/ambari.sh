#! /bin/bash

# install ambari
wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.2.0/ambari.repo -O /etc/yum.repos.d/ambari.repo
yum -y install ambari-server
ambari-server setup -s
ambari-server start

# install ambari agent
yum -y install ambari-agent
ambari-agent start
