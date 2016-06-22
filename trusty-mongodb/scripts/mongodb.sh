#! /bin/bash

MONGODB_VERSION=$1

# Add MongoDB repo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# Install the specified server version
apt-get update  > /dev/null
sudo apt-get install -y mongodb-org=$MONGODB_VERSION mongodb-org-server=$MONGODB_VERSION mongodb-org-shell=$MONGODB_VERSION mongodb-org-mongos=$MONGODB_VERSION mongodb-org-tools=$MONGODB_VERSION

# Start the service and bind to all ips for external access
# DO NOT DO THIS IN A PRODUCTION ENVIRONMENT
sudo sed -i "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf
service mongod restart
