#! /bin/bash

sudo sh -c "echo 'mysql-server-5.5 mysql-server/root_password password root' | debconf-set-selections"
sudo sh -c "echo 'mysql-server-5.5 mysql-server/root_password_again password root' | debconf-set-selections"

apt-get install -y hive hive-metastore hive-server2 mysql-server libmysql-java > /dev/null 2>&1
ln -s /usr/share/java/mysql-connector-java.jar /usr/lib/hive/lib/mysql-connector-java.jar

cp /vagrant/conf/hive-site.xml /etc/hive/conf/hive-site.xml

sudo mysql -uroot -proot -e "CREATE DATABASE metastore DEFAULT CHARACTER SET 'latin1'"
sudo mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON metastore.* TO hive@localhost IDENTIFIED BY 'hive'"
sudo mysql -uroot -proot -e "FLUSH PRIVILEGES"
sudo mysql -uroot -proot metastore < /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-0.14.0.mysql.sql

sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
service mysql restart

for x in `cd /etc/init.d ; ls hive-*` ; do sudo service $x stop ; done
for x in `cd /etc/init.d ; ls hive-*` ; do sudo service $x start ; done