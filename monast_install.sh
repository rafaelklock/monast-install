#!/bin/bash


MANAGER_FILE="/etc/asterisk/manager.conf"



apt update
apt install php-pear git python-pip -y

git clone https://github.com/dagmoller/monast.git
bash monast/install.sh

cp monast.conf /etc/monast.conf

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

python get-pip.py
python -m pip install --upgrade pip setuptools wheel
pip2 install twisted

wget https://sourceforge.net/projects/starpy/files/starpy/1.0.0a13/starpy-1.0.0a13.tar.gz -O starpy.tgz
tar zxvf starpy.tgz
cd starpy*
pip install .

pear install HTTP_Client
# pear upgrade --force --alldeps http://pear.php.net/get/PEAR-1.10.1

if [ $(grep moneast /etc/asterisk/manager.conf) ] ; then
	echo "Monast ja esta no manager.conf"
else
	echo "Configurando o manager.conf"
	echo "" >> $MANAGER_FILE
	echo "[monast]" >> $MANAGER_FILE
	echo secret=batata#descascada7 >> $MANAGER_FILE
	echo writetimeout=100 >> $MANAGER_FILE
	echo read=system,call,log,verbose,command,agent,user,config,originate,reporting >> $MANAGER_FILE
	echo write=system,call,log,verbose,command,agent,user,config,originate,reporting >> $MANAGER_FILE
	echo "" >> $MANAGER_FILE
fi

echo "FIM!"
