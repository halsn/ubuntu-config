#!/usr/bin/env bash

#换163源
sudo sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
sudo apt-get update

#必备软件
sudo apt-get install -y git ibus-rime ppa-purge apt-file tree time curl wget

#Lantern
wget https://raw.githubusercontent.com/getlantern/lantern-binaries/master/lantern-installer-beta-64-bit.deb -O lantern.deb
sudo dpkg -i lantern.deb
sudo apt-get install -f

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
git clone https://github.com/halsn/ubuntu-config && cd ubuntu-config
cp .* $HOME
export http_proxy=http://127.0.0.1:42005

#NVim
curl https://raw.githubusercontent.com/halsn/neovim-config/master/install.sh | sh

#Robomongo
proxy wget https://download.robomongo.org/0.9.0/linux/robomongo-0.9.0-linux-x86_64-0786489.tar.gz -O robomonto.tar.gz
tar -zxf robomongo.tar.gz && cd robomongo
ROBODIR=$(pwd)
cd /usr/local/bin/
sudo ln -s $ROBODIR/bin/robomongo .
