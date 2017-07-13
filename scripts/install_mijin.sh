#!/bin/sh -x
#
#
INSTALL_HOME=/home/mijin
LOG=$INSTALL_HOME/mijin_install.log

MIJIN_INSTALLER_URL=$1
ADDITIONAL_LOCAL_IPS=$2
MIJIN_HOST_1=$3
MIJIN_HOST_2=$4
MIJIN_HOST_3=$5
MIJIN_HOST_4=$6
MIJIN_HOST_5=$7


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
tar zxvf m.tar.gz
cd mijin
tar zxvf serverjars.tgz

IP=`curl ifconfig.co`
sed -e "s/%IP%/$IP/" config-user.properties.org >config-user.properties.ip
sed -e "s/%AddItionalLocalIps%/$ADDITIONAL_LOCAL_IPS/" config-user.properties.ip >config-user.properties

sed -e "s/%IP1%/$MIJIN_HOST_1/" peers-config_mijinnet.json.org >peers-config_mijinnet.json.ip1
sed -e "s/%IP2%/$MIJIN_HOST_2/" peers-config_mijinnet.json.ip1 >peers-config_mijinnet.json.ip2
sed -e "s/%IP3%/$MIJIN_HOST_3/" peers-config_mijinnet.json.ip2 >peers-config_mijinnet.json.ip3
sed -e "s/%IP4%/$MIJIN_HOST_4/" peers-config_mijinnet.json.ip3 >peers-config_mijinnet.json.IP4
sed -e "s/%IP5%/$MIJIN_HOST_5/" peers-config_mijinnet.json.ip4 >peers-config_mijinnet.json

DIR=`pwd`
echo "@reboot screen -S mijin -d -m $DIR/startnem.sh" | sort - | uniq - | crontab -

screen -S mijin  -d -m $DIR/startnem.sh
