#!/usr/bin/env bash

sudo apt-get update

#必备软件
sudo apt-get install -y git ibus-rime ppa-purge tree time curl wget gawk wordnet entr

#Lantern
wget https://raw.githubusercontent.com/getlantern/lantern-binaries/master/lantern-installer-beta-64-bit.deb -O lantern.deb
sudo dpkg -i lantern.deb
sudo apt-get install -f
# echo "----------打开Lantern查看端口------------"
# echo "----------HTTP端口------------"
# read HTTPPORT
# echo "----------SOCKT5端口------------"
# read SOCKTPORT
# sudo sed -i 's/^proxy_dns/\#proxy_dns/g' /etc/proxychains.conf
# sudo sed -i 's/^socks4\s\s127.0.0.1\s9050//g' /etc/proxychains.conf
# echo "http 127.0.0.1 $HTTPPORT" | sudo tee -a /etc/proxychains.conf
# echo "sockt5 127.0.0.1 $SOCKTPORT" | sudo tee -a /etc/proxychains.conf

#Docker
curl -sSL https://get.daocloud.io/docker | sh
sudo usermod -aG docker $USER
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://26cc5846.m.daocloud.io
sudo systemctl restart docker.service

#MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo service mongod start
echo "sudo service mongod start" | sudo tee -a /etc/rc.local

#配置文件
cd $HOME
git clone git@github.com:halsn/ubuntu-config && cd ubuntu-config
cp -a .bashrc $HOME
cp -a ./App $HOME
sudo cp -a ./config/rc.local /etc/

# Node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
source $HOME/.nvm/nvm.sh
source $HOME/.profile
source $HOME/.bashrc
nvm install stable
npm install js-beautify eslint_d babel-eslint eslint-config-airbnb eslint-plugin-import eslint-plugin-react eslint-plugin-jsx-a11y htmlhint eslint jsonlint csslint -g

#NVim
curl -o- https://raw.githubusercontent.com/halsn/neovim-config/master/install.sh | sh

#Robomongo
proxy wget https://download.robomongo.org/0.9.0/linux/robomongo-0.9.0-linux-x86_64-0786489.tar.gz -O robomonto.tar.gz
tar -zxf robomongo.tar.gz && cd robomongo
ROBODIR=$(pwd)
cd /usr/local/bin/
sudo ln -s $ROBODIR/bin/robomongo .
