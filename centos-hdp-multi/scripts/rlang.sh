#! /bin/bash

# Install epel-release repository
yum -y install epel-release
yum -y update

# Install R
yum -y install R

# Install the rJava package
mkdir -p /opt/R/packages
R CMD javareconf JAVA_HOME=/usr/jdk64/jdk1.8.0_60
Rscript -e 'install.packages("rJava", lib="/opt/R/packages", repos="http://cran.r-project.org")'

# set the R environment settings
echo "export R_HOME=/usr/lib64/R" >> /etc/profile.d/rlang.sh
echo "export R_LIBS_USER=/opt/R/packages" >> /etc/profile.d/rlang.sh
