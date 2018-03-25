# Hortonworks HDP Vagrant Template

## Dependencies

| Plugin | Installation |
| --- |--- |
| vbguest | vagrant plugin install vagrant-vbguest |
| hostmanager | vagrant plugin install vagrant-hostmanager |
| timezone | vagrant plugin install vagrant-timezone |

## Installation Notes

# Using ambari to provision the cluster
After the initial provisioning, open the vm 8080 port in the host browser and proceed with the installation. The host private key used in the template is in the rsa folder.

# Automated deployment with provided blueprints
Open an ssh console (vagrant ssh) and deploy one of the available blueprints in the blueprint folder.

Installation with default values
```
curl -H "X-Requested-By: ambari" -X POST -u admin:admin "http://centos-hdp:8080/api/v1/blueprints/single-node-centos-hdp" -d @/vagrant/blueprint/single_node_blueprint_default.json
curl -H "X-Requested-By: ambari" -X POST -u admin:admin "http://centos-hdp:8080/api/v1/clusters/hdp" -d @/vagrant/blueprint/single_node_host_mapping.json
```

Installation customized for an 8Gb VM
```
curl -H "X-Requested-By: ambari" -X POST -u admin:admin "http://centos-hdp:8080/api/v1/blueprints/single-node-centos-hdp" -d @/vagrant/blueprint/single_node_blueprint_custom.json
curl -H "X-Requested-By: ambari" -X POST -u admin:admin "http://centos-hdp:8080/api/v1/clusters/hdp" -d @/vagrant/blueprint/single_node_host_mapping.json
```

### Cluster Configuration for Pentaho 8

```
sudo -u hdfs hadoop fs -mkdir -p /user/vagrant
sudo -u hdfs hadoop fs -chown vagrant /user/vagrant
sudo -u hdfs hadoop fs -mkdir -p /opt
sudo -u hdfs hadoop fs -chmod -R 1777 /opt
```
