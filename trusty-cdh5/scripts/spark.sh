#! /bin/bash

HOSTNAME=$(hostname -f)

# install base spark packages
apt-get -qq install -y spark-core spark-history-server spark-python

# setup hdfs folders
sudo -u hdfs hadoop fs -mkdir /user/spark
sudo -u hdfs hadoop fs -mkdir /user/spark/applicationHistory
sudo -u hdfs hadoop fs -mkdir -p /user/spark/share/lib
sudo -u hdfs hadoop fs -put /usr/lib/spark/lib/spark-assembly-*.jar /user/spark/share/lib/spark-assembly.jar
sudo -u hdfs hadoop fs -chown -R spark:spark /user/spark
sudo -u hdfs hadoop fs -chmod 1777 /user/spark/applicationHistory

# setup spark yarn conf
echo "spark.eventLog.dir=hdfs://$HOSTNAME:8020/user/spark/applicationHistory" >> /etc/spark/conf/spark-defaults.conf
echo "spark.eventLog.enabled=true" >> /etc/spark/conf/spark-defaults.conf
echo "spark.yarn.historyServer.address=http://$HOSTNAME:18080" >> /etc/spark/conf/spark-defaults.conf

# restart the history server
sudo service spark-history-server restart
