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

# Update and set defaults
apt-get update > /dev/null

# Remove the 127.0.1.1 entry from the hosts file
sed -i "s/127.0.1.1.*//" /etc/hosts
