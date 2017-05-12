#! /bin/bash

cat >> /etc/apt/sources.list.d/kafka-cloudera.list <<EOF
deb [arch=amd64] https://archive.cloudera.com/kafka/ubuntu/trusty/amd64/kafka/ trusty-kafka2 contrib
deb-src https://archive.cloudera.com/kafka/ubuntu/trusty/amd64/kafka/ trusty-kafka2 contrib
EOF

# Update sources and install kafka
apt-get -qq update
apt-get -qq install -y kafka kafka-server

# Start a single kafka server
service kafka-server start
