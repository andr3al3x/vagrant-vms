#! /bin/bash

yum install -y http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
yum install -y mysql-community-server

MYSQL_PASS=$(sudo cat /var/log/mysqld.log | grep "A temporary password is generated for" | awk '{print $NF}')
mysql -uroot -p$MYSQL_PASS --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Root#123'"
mysql -uroot -pRoot#123 -e "create user 'vagrant'@'%' identified by 'Vagrant#123'"
mysql -uroot -pRoot#123 -e "create database vagrant"
mysql -uroot -pRoot#123 -e "grant all privileges on vagrant.* to vagrant@'%'"
