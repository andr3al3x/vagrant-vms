#! /bin/bash

pentaho_version=$1

echo "Provisioning Pentaho $pentaho_version"

# Unpack the zip files
sudo -u vagrant unzip /vagrant-files/biserver-ee-$pentaho_version-dist.zip -d /home/vagrant/
sudo -u vagrant unzip /vagrant-files/paz-plugin-ee-$pentaho_version-dist.zip -d /home/vagrant/
sudo -u vagrant unzip /vagrant-files/pir-plugin-ee-$pentaho_version-dist.zip -d /home/vagrant/
sudo -u vagrant unzip /vagrant-files/pdd-plugin-ee-$pentaho_version-dist.zip -d /home/vagrant/

# Install the BI server
sudo -u vagrant java -DINSTALL_PATH=/home/vagrant/pentaho -jar /home/vagrant/biserver-ee-$pentaho_version/installer.jar -options-system

# Install the plugins
sudo -u vagrant java -DINSTALL_PATH=/home/vagrant/pentaho-plugins -jar /home/vagrant/paz-plugin-ee-$pentaho_version/installer.jar -options-system
sudo -u vagrant java -DINSTALL_PATH=/home/vagrant/pentaho-plugins -jar /home/vagrant/pir-plugin-ee-$pentaho_version/installer.jar -options-system
sudo -u vagrant java -DINSTALL_PATH=/home/vagrant/pentaho-plugins -jar /home/vagrant/pdd-plugin-ee-$pentaho_version/installer.jar -options-system
rm /home/vagrant/pentaho-plugins/*eula*
sudo -u vagrant mv /home/vagrant/pentaho-plugins/* /home/vagrant/pentaho/biserver-ee/pentaho-solutions/system

# Cleanup
rm -rf /home/vagrant/biserver-ee-$pentaho_version
rm -rf /home/vagrant/paz-plugin-ee-$pentaho_version
rm -rf /home/vagrant/pir-plugin-ee-$pentaho_version
rm -rf /home/vagrant/pdd-plugin-ee-$pentaho_version
rm -rf /home/vagrant/pentaho-plugins

# Install PostgreSQL
apt-get install -y postgresql > /dev/null 2>&1

# Setup the PostgreSQL repos
sudo -u postgres psql < /home/vagrant/pentaho/biserver-ee/data/postgresql/create_repository_postgresql.sql > /dev/null 2>&1
sudo -u postgres psql < /home/vagrant/pentaho/biserver-ee/data/postgresql/create_jcr_postgresql.sql > /dev/null 2>&1
sudo -u postgres psql < /home/vagrant/pentaho/biserver-ee/data/postgresql/create_quartz_postgresql.sql > /dev/null 2>&1

# configure postgres to accept remote connections
cat >> /etc/postgresql/9.3/main/pg_hba.conf <<EOF
# Accept all IPv4 connections
host    all         all         0.0.0.0/0             md5
EOF

service postgresql restart

# Start Pentaho
rm /home/vagrant/pentaho/biserver-ee/promptuser.sh
sudo -u vagrant sh /home/vagrant/pentaho/biserver-ee/start-pentaho.sh