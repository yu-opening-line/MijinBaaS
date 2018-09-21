#!/bin/sh -x
#
#

ADDITIONAL_LOCAL_IPS=$1
MIJIN_HOST_1=$2
MIJIN_HOST_2=$3
MIJIN_HOST_3=$4
MIJIN_HOST_4=$5
MIJIN_HOST_5=$6
MIJIN_INSTALLER_URL=$7
USERNAME=$8
SERVER_NUM=$9


BOOT_NAME_1='mijinnode1'
BOOT_KEY_1='dd214532115faa938e2982ef0b6a743b2b421fdf90337b8d05da006235864722'

BOOT_NAME_2='mijinnode2'
BOOT_KEY_2='862e914837ab085592b5327ce73a96e62450ac50ac55fa0ecfadba171907132f'

BOOT_NAME_3='mijinnode3'
BOOT_KEY_3='a8207ae07e71e16c1a6c985669da4b1f1c980ddd794d2627e00a88d8a46c0c32'

BOOT_NAME_4='mijinnode4'
BOOT_KEY_4='fe421fe9e287e27962206e86f72d2a6fbf40ed074526b71c0d87556b17203184'

BOOT_NAME_5='mijinnode5'
BOOT_KEY_5='cd90f2891cb60bf492b12c4032acdb5c44a5e483984a111e47a810a820a3916b'


BOOT_NAME=
BOOT_KEY=

if [ $SERVER_NUM -eq 0 ]; then
  BOOT_NAME=$BOOT_NAME_1
  BOOT_KEY=$BOOT_KEY_1

elif [ $SERVER_NUM -eq 1 ]; then
  BOOT_NAME=$BOOT_NAME_2
  BOOT_KEY=$BOOT_KEY_2

elif [ $SERVER_NUM -eq 2 ]; then
  BOOT_NAME=$BOOT_NAME_3
  BOOT_KEY=$BOOT_KEY_3

elif [ $SERVER_NUM -eq 3 ]; then
  BOOT_NAME=$BOOT_NAME_4
  BOOT_KEY=$BOOT_KEY_4

elif [ $SERVER_NUM -eq 4 ]; then
  BOOT_NAME=$BOOT_NAME_5
  BOOT_KEY=$BOOT_KEY_5

else
  # 上記以外なら、エラー終了
  echo 'Invalid Paramater!' 1>&2
  exit 1
fi

INSTALL_HOME=/home/$USERNAME
LOG=$INSTALL_HOME/mijin_install.log

#yum -y update -x WALinuxAgent
yum -y install wget
yum -y install screen
yum -y install java-1.8.0

systemctl start firewalld.service
firewall-cmd --permanent --add-port=7778/tcp
firewall-cmd --permanent --add-port=7895/tcp
firewall-cmd --reload
systemctl enable firewalld.service

cd $INSTALL_HOME

INSTALLER=`echo $MIJIN_INSTALLER_URL | sed -r 's/^.*(mijin\..*\.tar\.gz)/\1/'`

wget $MIJIN_INSTALLER_URL -O $INSTALLER

tar zxvf $INSTALLER

rm -f $INSTALLER

cd mijin
tar zxvf serverjars.tgz


HOST_IP=`curl ifconfig.co`
sed -e "s/%IP%/$HOST_IP/" config-user.properties.org >config-user.properties.org1
sed -e "s/%AddItionalLocalIps%/$ADDITIONAL_LOCAL_IPS/" config-user.properties.org1 >config-user.properties.org2
sed -e "s/%BOOT_NAME%/$BOOT_NAME/" config-user.properties.org2 >config-user.properties.org3
sed -e "s/%BOOT_KEY%/$BOOT_KEY/" config-user.properties.org3 >config-user.properties

sed -e "s/%IP1%/$MIJIN_HOST_1/" peers-config_mijinnet.json.org >peers-config_mijinnet.json.ip1
sed -e "s/%IP2%/$MIJIN_HOST_2/" peers-config_mijinnet.json.ip1 >peers-config_mijinnet.json.ip2
sed -e "s/%IP3%/$MIJIN_HOST_3/" peers-config_mijinnet.json.ip2 >peers-config_mijinnet.json.ip3
sed -e "s/%IP4%/$MIJIN_HOST_4/" peers-config_mijinnet.json.ip3 >peers-config_mijinnet.json.ip4
sed -e "s/%IP5%/$MIJIN_HOST_5/" peers-config_mijinnet.json.ip4 >peers-config_mijinnet.json

rm -f config-user.properties.org
rm -f config-user.properties.org1
rm -f config-user.properties.org2
rm -f config-user.properties.org3

rm -f peers-config_mijinnet.json.org
rm -f peers-config_mijinnet.json.ip1
rm -f peers-config_mijinnet.json.ip2
rm -f peers-config_mijinnet.json.ip3
rm -f peers-config_mijinnet.json.ip4

rm -f ./.DS_Store
rm -f ./._*
rm -f ./serverjars/.DS_Store
rm -f ./serverjars/._*

DIR=`pwd`
echo "@reboot screen -S mijin -d -m $DIR/startnem.sh" | sort - | uniq - | crontab -

screen -S mijin  -d -m $DIR/startnem.sh
