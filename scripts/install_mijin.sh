#!/bin/sh -x
#
#

ADDITIONAL_LOCAL_IPS=$1
MIJIN_HOST_1=$2
MIJIN_HOST_2=$3
#MIJIN_HOST_3=$4
#MIJIN_HOST_4=$5
#MIJIN_HOST_5=$6
MIJIN_INSTALLER_URL=$4
USERNAME=$5

INSTALL_HOME=/home/$USERNAME
LOG=$INSTALL_HOME/mijin_install.log

su - mijin

#yum -y update -x WALinuxAgent
sudo yum -y install screen
sudo yum -y install java-1.8.0

sudo systemctl start firewalld.service
sudo firewall-cmd --permanent --add-port=7778/tcp
sudo firewall-cmd --permanent --add-port=7895/tcp
sudo firewall-cmd --reload
sudo systemctl enable firewalld.service

cd $INSTALL_HOME
