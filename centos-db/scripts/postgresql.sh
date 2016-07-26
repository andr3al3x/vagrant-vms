#! /bin/bash

POSTGRES_DATA_DIR=/var/lib/pgsql/9.5/data

# install latest version
yum install -y https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm
yum install -y postgresql95-server
/usr/pgsql-9.5/bin/postgresql95-setup initdb
service postgresql-9.5 start

# setup external access
sed -i "s/^#listen_addresses.*$/listen_addresses = '*'/" $POSTGRES_DATA_DIR/postgresql.conf
sed -i 's/ident/md5/' $POSTGRES_DATA_DIR/pg_hba.conf
echo 'host    all             all             0.0.0.0/0               md5' >> $POSTGRES_DATA_DIR/pg_hba.conf

# create vagrant user and set a password for postgres
ALTER_POSTGRES_USER_SQL="ALTER USER postgres WITH ENCRYPTED PASSWORD 'postgres'"
sudo -u postgres psql --command="$ALTER_POSTGRES_USER_SQL"
CREATE_USER_SQL="CREATE ROLE vagrant PASSWORD 'vagrant' CREATEDB INHERIT LOGIN;"
sudo -u postgres psql --command="$CREATE_USER_SQL"
ALTER_USER_SQL="ALTER USER vagrant WITH ENCRYPTED PASSWORD 'vagrant'"
sudo -u postgres psql --command="$ALTER_USER_SQL"
CREATE_USER_DB_SQL="CREATE DATABASE vagrant WITH OWNER=vagrant"
sudo -u postgres psql --command="$CREATE_USER_DB_SQL"

# reset the server
service postgresql-9.5 restart
