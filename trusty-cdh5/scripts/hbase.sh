#! /bin/bash

sudo apt-get install -y hbase hbase-master hbase-thrift hbase-regionserver zookeeper-server > /dev/null 2>&1
sudo service zookeeper-server init
sudo service zookeeper-server start

cp /vagrant/conf/hbase-site.xml /etc/hbase/conf/hbase-site.xml

for x in `cd /etc/init.d ; ls hbase-*` ; do sudo service $x stop ; done
for x in `cd /etc/init.d ; ls hbase-*` ; do sudo service $x start ; done