#!/bin/sh -x
#
#
LOG=$HOME/mijin_install.log
sudo yum -y update 
sudo yum -y install screen
sudo yum -y install java-1.8.0

sudo systemctl start firewalld.service
sudo firewall-cmd --permanent --add-port=7778/tcp
sudo firewall-cmd --permanent --add-port=7895/tcp
sudo firewall-cmd --reload
sudo systemctl enable firewalld.service

wget https://raw.githubusercontent.com/RyoOpeningLine/Test/master/m.tar.gz
tar zxvf m.tar.gz
cd mijin
tar zxvf serverjars.tgz

IP=`curl ifconfig.co`
sed -e "s/%IP%/$IP/" config-user.properties.org >config-user.properties
sed -e "s/%IP%/$IP/" peers-config_mijinnet.json.org >peers-config_mijinnet.json

DIR=`pwd`
echo "@reboot screen -S mijin -d -m $DIR/startnem.sh" | sort - | uniq - | crontab -

screen -S mijin  -d -m $DIR/startnem.sh

