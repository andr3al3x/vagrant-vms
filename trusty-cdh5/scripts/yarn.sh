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
apt-get update > /dev/null

# Install base hadoop
apt-get install -y hadoop-conf-pseudo

# Format the namenode
sudo -u hdfs hdfs namenode -format > /dev/null 2>&1

# Start the HDFS Services
for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done

# Create the appropriate HDFS directories
sh /usr/lib/hadoop/libexec/init-hdfs.sh
sudo -u hdfs hadoop fs -mkdir -p /user/vagrant
sudo -u hdfs hadoop fs -chown vagrant /user/vagrant
sudo -u hdfs hadoop fs -mkdir -p /opt
sudo -u hdfs hadoop fs -chmod -R 1777 /opt

# Setup the history server permissions correctly
sudo -u hdfs hadoop fs -mkdir -p /var/log /var/log/hadoop-yarn/apps /user/history
sudo -u hdfs hadoop fs -chmod -R 1777 /user/history
sudo -u hdfs hadoop fs -chown mapred:hadoop /user/history
sudo -u hdfs hadoop fs -chmod -R 1777 /var/log/hadoop-yarn/apps
sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn/apps

# Start YARN services
service hadoop-yarn-resourcemanager start
service hadoop-yarn-nodemanager start
service hadoop-mapreduce-historyserver start

# Set hadoop services to listen on the appropriate hostname
sed -i "s/localhost/$HOSTNAME/g" /etc/hadoop/conf/core-site.xml
sed -i "s/localhost/$HOSTNAME/g" /etc/hadoop/conf/mapred-site.xml
