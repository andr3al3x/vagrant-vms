#! /bin/bash

HOSTNAME=$(hostname -f)
CLOUDERA_CDH_VERSION=$1

# Add Cloudera Repo
wget http://archive.cloudera.com/cdh5/one-click-install/trusty/amd64/cdh5-repository_1.0_all.deb
dpkg -i cdh5-repository_1.0_all.deb
rm cdh5-repository_1.0_all.deb

wget https://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key -O archive.key
sudo apt-key add archive.key

cat >> /etc/apt/preferences.d/cloudera.pref <<EOF
Package: *
Pin: release o=Cloudera, l=Cloudera
Pin-Priority: 501
EOF

# make the cloudera CDH version fixed
sed -i "s/trusty-cdh5/trusty-cdh$CLOUDERA_CDH_VERSION/g" /etc/apt/sources.list.d/cloudera-cdh5.list

# Update and set defaults
apt-get -qq update

# Install base hadoop
apt-get -qq install -y hadoop-conf-pseudo pig zookeeper-server

# Format the namenode
sudo -u hdfs hdfs namenode -format

# Start the HDFS Services
for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done

# Create the appropriate HDFS directories
sh /usr/lib/hadoop/libexec/init-hdfs.sh
sudo -u hdfs hadoop fs -mkdir -p /user/vagrant
sudo -u hdfs hadoop fs -chown vagrant /user/vagrant
sudo -u hdfs hadoop fs -mkdir -p /opt
sudo -u hdfs hadoop fs -chmod -R 1777 /opt

# Set hadoop services to listen on the appropriate hostname
sed -i "s/localhost/$HOSTNAME/g" /etc/hadoop/conf/core-site.xml
sed -i "s/localhost/$HOSTNAME/g" /etc/hadoop/conf/mapred-site.xml

# Add Hive proxyuser settings
sed -i '$ d' /etc/hadoop/conf/core-site.xml
cat >> /etc/hadoop/conf/core-site.xml << EOL
  <!-- Hive proxy settings so Spark execution does not complain -->
  <property>
    <name>hadoop.proxyuser.hive.groups</name>
    <value>*</value>
  </property>
  <property>
    <name>hadoop.proxyuser.hive.hosts</name>
    <value>*</value>
  </property>
</configuration>
EOL

# Restart HDFS services
service hadoop-hdfs-namenode restart
service hadoop-hdfs-datanode restart
service hadoop-hdfs-secondarynamenode restart

# Restart YARN services
service hadoop-yarn-resourcemanager restart
service hadoop-yarn-nodemanager restart
service hadoop-mapreduce-historyserver restart

# Initialize zookeeper 
service zookeeper-server init
service zookeeper-server start
