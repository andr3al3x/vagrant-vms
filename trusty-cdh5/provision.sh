#! /bin/bash

# Turn off ubuntu interactive mode
export DEBIAN_FRONTEND=noninteractive

# Set the timezone
echo "Europe/Lisbon" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# Set the kb layout
sed -i 's/"pc105"/"macbook79"/g' /etc/default/keyboard
sed -i 's/"us"/"pt"/g' /etc/default/keyboard
apt-get install -y console-common
install-keymap pt

# Disable IPV6 and set swappiness to 1
grep net.ipv6.conf.all.disable_ipv6 /etc/sysctl.conf || (echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf)
grep net.ipv6.conf.default.disable_ipv6 /etc/sysctl.conf || (echo "net.ipv6.conf.default.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf)
grep net.ipv6.conf.lo.disable_ipv6 /etc/sysctl.conf || (echo "net.ipv6.conf.lo.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf)
grep vm.swappiness /etc/sysctl.conf || (echo "vm.swappiness = 1" | sudo tee -a /etc/sysctl.conf)
sysctl -p

# Add Java Repo
add-apt-repository -y ppa:webupd8team/java > /dev/null 2>&1

# Add Cloudera Repo
wget http://archive.cloudera.com/cdh5/one-click-install/trusty/amd64/cdh5-repository_1.0_all.deb
dpkg -i cdh5-repository_1.0_all.deb
rm cdh5-repository_1.0_all.deb

# Update and set defaults
apt-get update > /dev/null
sh -c "echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections"
sh -c "echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections"

# Install Java
apt-get install -y oracle-java7-installer > /dev/null 2>&1

# Install base hadoop
apt-get install -y hadoop-conf-pseudo

# Format the namenode
sudo -u hdfs hdfs namenode -format > /dev/null 2>&1

# Start the HDFS Services
for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done

# Create the appropriate HDFS directories
sh /usr/lib/hadoop/libexec/init-hdfs.sh
sudo -u hdfs hadoop fs -mkdir -p /user/puls3
sudo -u hdfs hadoop fs -chown puls3 /user/puls3
sudo -u hdfs hadoop fs -mkdir -p /opt 
sudo -u hdfs hadoop fs -chmod -R 1777 /opt

# Start YARN services
service hadoop-yarn-resourcemanager start
service hadoop-yarn-nodemanager start 
service hadoop-mapreduce-historyserver start

# Set hadoop services to listen on the appropriate hostname
sed -i 's/localhost/trusty-cdh5/g' /etc/hadoop/conf/core-site.xml
sed -i 's/localhost/trusty-cdh5/g' /etc/hadoop/conf/mapred-site.xml

reboot