#!/bin/sh -x
#
#
INSTALL_HOME=/home/mijin
LOG=$INSTALL_HOME/mijin_install.log

MIJIN_INSTALLER_URL=$1
ADDITIONAL_LOCAL_IPS=$2


#yum -y update -x WALinuxAgent
yum -y install screen
yum -y install java-1.8.0

systemctl start firewalld.service
firewall-cmd --permanent --add-port=7778/tcp
firewall-cmd --permanent --add-port=7895/tcp
firewall-cmd --reload
systemctl enable firewalld.service

cd $INSTALL_HOME

wget $MIJIN_INSTALLER_URL
