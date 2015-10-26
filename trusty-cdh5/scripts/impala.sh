#! /bin/bash

apt-get install -y impala impala-server impala-state-store impala-catalog impala-shell

for x in `cd /etc/init.d ; ls impala-*` ; do sudo service $x stop ; done
for x in `cd /etc/init.d ; ls impala-*` ; do sudo service $x start ; done