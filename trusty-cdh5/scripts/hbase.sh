#! /bin/bash

apt-get -qq install -y hbase hbase-master hbase-thrift hbase-regionserver

cp /vagrant/conf/hbase-site.xml /etc/hbase/conf/hbase-site.xml

for x in `cd /etc/init.d ; ls hbase-*` ; do sudo service $x stop ; done
for x in `cd /etc/init.d ; ls hbase-*` ; do sudo service $x start ; done
