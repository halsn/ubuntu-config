#!/usr/bin/env bash

# Ask for the administrator password upfront.
sudo -v

set -e

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo apt update
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  proxychains4
curl -fsSL https://download.daocloud.io/docker/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=$(dpkg --print-architecture)] https://download.daocloud.io/docker/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
sudo apt install -y -q docker-ce=*
sudo service docker start
sudo usermod -aG docker $USER
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
sudo systemctl restart docker.service
if [ ! "$(docker ps -a | grep ssclient)" ]; then
  sudo docker run -dt --name ssclient --restart=always -p 1080:1080 mritd/shadowsocks -m "ss-local" -s "-s $SSHOST -p $SSPORT -b 0.0.0.0 -l 1080 -m chacha20-ietf-poly1305 -k $SSPASS" -x -e "kcpclient" -k "-r $SSHOST:$SSPORT -l :$SSPORT -mode fast2"
fi

curl -SL -o setup.sh https://raw.githubusercontent.com/halsn/ubuntu-config/master/setup.sh
curl -SL -o proxychains.conf https://raw.githubusercontent.com/halsn/ubuntu-config/master/config/proxychains.conf

proxychains4 -f ./proxychains.conf sh setup.sh

rm -rf setup.sh
rm -rf proxychains.conf

set +e
