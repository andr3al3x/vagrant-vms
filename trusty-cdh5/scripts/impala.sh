#! /bin/bash

apt-get -qq install -y impala impala-server impala-state-store impala-catalog impala-shell

ln -s /etc/hadoop/conf/hdfs-site.xml /etc/impala/conf/hdfs-site.xml
ln -s /etc/hadoop/conf/core-site.xml /etc/impala/conf/core-site.xml
ln -s /etc/hive/conf/hive-site.xml /etc/impala/conf/hive-site.xml

for x in `cd /etc/init.d ; ls impala-*` ; do sudo service $x stop ; done
for x in `cd /etc/init.d ; ls impala-*` ; do sudo service $x start ; done
