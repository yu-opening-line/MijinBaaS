#!/bin/sh -x
#
#
echo -e 'y\n' | ssh-keygen -f .ssh/id_rsa -t rsa -N ""

cat .ssh/id_rsa.pub >>.ssh/authorized_keys
ssh -tt mijin@localhost "sudo echo 'Defaults    !requiretty' >>/etc/sudoers"
sudo -S yum -y install screen

