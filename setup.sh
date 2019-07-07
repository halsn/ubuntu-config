#!/usr/bin/env bash

# Ask for the administrator password upfront.
sudo -v

set -e

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# check if is on windows sub linux system
wsl=0;

if grep -q Microsoft /proc/version; then
  wsl=1
else
  wsl=0
fi

sudo apt update

#必备软件
bootstrap() {
  echo "-----------bootstrap-------------"
  sudo apt install -y ibus-rime ppa-purge tree time curl wget gawk wordnet entr inotify-tools silversearcher-ag htop ncdu exuberant-ctags unity-tweak-tool nyancat vim
  echo "------------finished-------------"
  echo ""
}

config_ssh() {
  echo "---------------ssh---------------"
  if [ -d $HOME/.ssh ]; then
    echo "ssh dir already exist! pass!"
    echo "------------finished-------------"
    echo ""
    return 0
  fi
  ssh-keygen -t rsa -b 4096 -C "xuhalsn@gmail.com"
  # 没有这个命令会出现无法clone的问题
  # https://askubuntu.com/questions/762541/ubuntu-16-04-ssh-sign-and-send-pubkey-signing-failed-agent-refused-operation
  ssh-add
  echo "------------finished-------------"
  echo ""
}

config_git() {
  echo "---------------git---------------"
  if test $(which git) -a $wsl -eq 0; then
    echo "git already installed! pass!"
    echo "------------finished-------------"
    echo ""
    return 0
  fi
  sudo apt install -y git
  curl -u "halsn" \
    --data "{\"title\":\"VM_`date +%Y%m%d%H%M%S`\",\"key\":\"`cat ~/.ssh/id_rsa.pub`\"}" \
    https://api.github.com/user/keys
  git config --global user.email "xuhalsn@gmail.com"
  git config --global user.name "halsn"
  echo "------------finished-------------"
  echo ""
}

config_ubuntu() {
  echo "-------clone ubuntu-config-------"
  if [ -d $HOME/ubuntu-config ]; then
    echo "ubuntu-config dir already exist! pass!"
    echo "------------finished-------------"
    echo ""
    return 0
  fi
  cd $HOME
  git clone git@github.com:halsn/ubuntu-config.git && cd ubuntu-config
  cp -a ./dotfiles/. $HOME
  sudo cp -a ./config/rc.local /etc/
  source $HOME/.profile
  echo 'source ~/.base_bashrc' > $HOME/.bashrc
  source $HOME/.bashrc
  echo "-------------finished-------------"
  echo ""
}

# Docker
config_docker() {
  echo "------------docker---------------"
  if test $(which docker); then
    echo "docker already installed! pass!"
    echo "------------finished-------------"
    echo ""
    return 0
  fi
  sudo apt-get update
  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
  curl -fsSL https://download.daocloud.io/docker/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
     "deb [arch=$(dpkg --print-architecture)] https://download.daocloud.io/docker/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
  sudo apt-get update
  sudo apt-get install -y -q docker-ce=*
  sudo service docker start
  sudo usermod -aG docker $USER
  curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
  sudo systemctl restart docker.service
  source $HOME/.profile
  source $HOME/.bashrc
  echo "----------finished---------------"
  echo ""
}

# Docker Compose
config_docker_compose() {
  echo "--------docker_compose-----------"
  if test $(which docker-compose); then
    echo "docker-compose already installed! pass!"
    echo "------------finished-------------"
    echo ""
    return 0
  fi
  curl -L https://get.daocloud.io/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` > ~/docker-compose
  chmod +x ~/docker-compose
  sudo mv ~/docker-compose /usr/local/bin/docker-compose
  curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose -o ~/docker-compose
  sudo mv ~/docker-compose /etc/bash_completion.d/docker-compose
  echo "------------finished-------------"
  echo ""
}

# Node
config_node() {
  echo "-------------node----------------"
  if test $(which node); then
    echo "node already installed! pass!"
    echo "------------finished-------------"
    echo ""
    return 0
  fi
  if [ ! -d $HOME/.nvm ]; then
    mkdir ~/.nvm
  fi
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
  source $HOME/.nvm/nvm.sh
  source $HOME/.profile
  source $HOME/.bashrc
  nvm install stable
  npm --registry=https://registry.npm.taobao.org --verbose i -g eslint eslint_d typescript htmlhint jsonlint csslint babel-eslint eslint-plugin-import eslint-plugin-node eslint-plugin-promise eslint-plugin-standard eslint-plugin-jest eslint-plugin-react yarn babel-cli webpack webpack-cli webpack-dev-server
  echo "-----------finished--------------"
  echo ""
}

# NVim
config_nvim() {
  echo "-------------nvim----------------"
  if test $(which nvim); then
    echo "nvim already installed! pass!"
    echo "------------finished-------------"
    echo ""
    return 0
  fi
  curl -o- https://raw.githubusercontent.com/halsn/neovim-config/master/install.sh | sh
  source $HOME/.profile
  source $HOME/.bashrc
  echo "-----------finished--------------"
  echo ""
}

# Coc server
config_coc() {
  echo "-------------coc--------------"
  if [ -d $HOME/.config/coc/extension ]; then
    echo "coc dir already exist! pass!"
    echo "------------finished-------------"
    echo ""
    return 0
  fi
  extensions="coc-tsserver coc-tslint coc-eslint coc-json coc-html coc-css coc-ultisnips coc-dictionary coc-lists coc-word"
  mkdir -P $HOME/.config/coc/extensions
  cd $HOME/.config/coc/extensions
  yarn add --ignore-engines $extensions
  echo "-----------finished--------------"
  echo ""
}

# fzf
config_fzf() {
  echo "-------------fzf----------------"
  if test $(which fzf); then
    echo "fzf already installed! pass!"
    echo "------------finished-------------"
    echo ""
    return 0
  fi
  if [ -d $HOME/.fzf ]; then
    rm -rf ~/.fzf
  fi
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
  source $HOME/.profile
  source $HOME/.bashrc
  echo "----------finished--------------"
  echo ""
}

# proxychains4
config_proxychains4() {
  echo "---------proxychains4-----------"
  if test $(which proxychains4); then
    echo "proxychains4 already installed! pass!"
    echo "------------finished-------------"
    echo ""
    return 0
  fi
  sudo apt install -y proxychains4
  cd $HOME/ubuntu-config
  sudo cp -a ./config/proxychains.conf /etc/
  echo "---------finished--------------"
  echo ""
}

config_ssclient() {
  echo "----------ssclient-------------"
  if [ "$(sudo docker ps -a | grep ssclient)" ]; then
    echo "ssclient already installed! pass!"
    echo "------------finished-------------"
    echo ""
    return 0
  fi
  sudo docker run -dt --name ssclient --restart=always -p 1080:1080 mritd/shadowsocks -m "ss-local" -s "-s $SSHOST -p $SSPORT -b 0.0.0.0 -l 1080 -m chacha20-ietf-poly1305 -k $SSPASS" -x -e "kcpclient" -k "-r $SSHOST:$SSPORT -l :$SSPORT -mode fast2"
  echo "---------finished--------------"
  echo ""
}

clean_up() {
  cd $HOME
  rm -rf ~/tmp
}

bootstrap
config_ssh
config_git
config_ubuntu
config_node
config_nvim
config_coc
config_fzf

if [ $wsl -eq 0 ]; then
  config_docker
  config_docker_compose
  config_ssclient
  config_proxychains4
fi

clean_up

set +e
