#!/usr/bin/env bash

sudo apt update

#必备软件
first_install() {
  sudo apt install -y git ibus-rime ppa-purge tree time curl wget gawk wordnet entr inotify-tools silversearcher-ag htop ncdu exuberant-ctags
}

config_ssh() {
  ssh-keygen -t rsa -b 4096 -C "xuhalsn@gmail.com"
  # 没有这个命令会出现无法clone的问题
  # https://askubuntu.com/questions/762541/ubuntu-16-04-ssh-sign-and-send-pubkey-signing-failed-agent-refused-operation
  ssh-add
}

config_git() {
  echo "---------------git---------------"
  curl -u "halsn" \
    --data "{\"title\":\"VM_`date +%Y%m%d%H%M%S`\",\"key\":\"`cat ~/.ssh/id_rsa.pub`\"}" \
    https://api.github.com/user/keys
  git config --global user.email "xuhalsn@gmail.com"
  git config --global user.name "halsn"
  echo "------------finished-------------"
}

config_ubuntu() {
  echo "--------------clone ubuntu-config---------------"
  cd $HOME
  git clone git@github.com:halsn/ubuntu-config && cd ubuntu-config
  cp -a ./dotfiles/. $HOME
  cp -a ./App $HOME
  sudo cp -a ./config/rc.local /etc/
  echo "-------------------finished---------------------"
}

#Lantern
config_lantern() {
  echo "---------------lantern---------------"
  wget https://raw.githubusercontent.com/getlantern/lantern-binaries/master/lantern-installer-beta-64-bit.deb -O lantern.deb
  sudo dpkg -i lantern.deb
  sudo apt-get install -f
  # echo "----------打开Lantern查看端口------------"
  # echo "---------------HTTP端口------------------"
  # read HTTPPORT
  # echo "alias proxy=\"http_proxy=http://127.0.0.1:$HTTPPORT\"" | tee -a $HOME/.bashrc
  echo "--------------finished-------------------"
}

#Docker
config_docker() {
  echo "--------------docker---------------"
  curl -sSL https://get.daocloud.io/docker | sh
  sudo usermod -aG docker $USER
  curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://26cc5846.m.daocloud.io
  sudo systemctl restart docker.service
  echo "------------finished---------------"
}

# Docker Compose
config_docker_compose() {
  echo "---------docker_compose------------"
  curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
  echo "------------finished---------------"
}

#MongoDB
config_mongo() {
  echo "---------------mongodb------------------"
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
  echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
  sudo apt-get update
  sudo apt-get install -y mongodb-org
  sudo service mongod start
  echo "sudo service mongod start" | sudo tee -a /etc/rc.local
  echo "--------------finished-----------------"
}

# Node
config_node() {
  echo "-----------------node------------------"
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
  source $HOME/.nvm/nvm.sh
  source $HOME/.profile
  source $HOME/.bashrc
  nvm install stable
  npm install http-server nodemon js-beautify htmlhint eslint eslint_d jsonlint csslint -g
  echo "---------------finished----------------"
}

#NVim
config_nvim() {
  echo "-----------------nvim-------------------"
  curl -o- https://raw.githubusercontent.com/halsn/neovim-config/master/install.sh | sh
  echo "---------------finished-----------------"
}

#fzf
config_fzf() {
  echo "---------------------fzf------------------"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
  echo "------------------finished----------------"
}

# Robomongo
config_robomongo() {
  echo "------------------robomongo----------------"
  wget https://download.robomongo.org/0.9.0/linux/robomongo-0.9.0-linux-x86_64-0786489.tar.gz -O robomongo.tar.gz
  tar -zxf robomongo.tar.gz && cd robomongo
  ROBODIR=$HOME/App/
  echo $ROBODIR
  cd /usr/local/bin/
  sudo ln -s $ROBODIR/bin/robomongo .
  echo "------------------finished-----------------"
}

# first_install
# config_ssh
# config_git
# config_ubuntu
# config_lantern
# config_docker
config_docker_compose
# config_mongo
# config_node
# config_nvim
# config_fzf
# config_robomongo
