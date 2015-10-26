#! /bin/bash

# Turn off ubuntu interactive mode
export DEBIAN_FRONTEND=noninteractive

# Set the timezone
echo "Europe/Lisbon" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# Set the kb layout
# Uncomment the next line if you're using a macbook
# sed -i 's/"pc105"/"macbook79"/g' /etc/default/keyboard
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

# Update and set defaults
apt-get update > /dev/null
sh -c "echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections"
sh -c "echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections"

# Install Java
apt-get install -y oracle-java7-installer > /dev/null 2>&1