# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi


# alias
alias cl="clear"
alias nim="nvim"
alias rm="rm -i"
alias ll='ls -alF --color=none'
alias la='ls -A --color=none'
alias l='ls -CF | more'
# google翻译
alias cmd="cmd.exe"
alias pmd="powershell.exe"

trs() {
  trans -t zh+en $1 | less
}

root () {
  cd `git rev-parse --show-toplevel`
}

# 查找同义词
synonym () {
  wordnet $1 -syns{n,v,a,r}
}

# 添加自己账户github repo, $1是repo name
add_github_repo() {
  curl -u halsn https://api.github.com/user/repos -d "{\"name\": \"$1\"}"
}

# 删除自己帐号github repo, $1是repo name
delete_github_repo() {
  curl -u halsn -X DELETE https://api.github.com/repos/halsn/$1
}

# 常用git push, $1是commit信息
git_commit() {
  git add . -A && git commit -m "${1}" && git push
}

# commit之前输入必要信息
git_job_msg() {
  read msg
  git add . -A && git commit -m "$msg" && git push
}

git_rm_branch() {
  git branch -d ${1} && git push origin --delete ${1}
}

# git clone from my user account
github_clone() {
  git clone git@github.com:halsn/$1
}

clone_site() {
  wget -P $1 -mpck -e robots=off --wait 1 -E $2
}

agf() {
  ag "$1" | fzf
}

# docker相关
alias docker_pid="docker inspect --format '{{.State.Pid}}'"
alias docker_ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias docker_rmi_none="docker images | grep none | awk '{print $3 }' | xargs docker rmi"
alias docker_rm_volume="docker volume ls -qf dangling=true | xargs -r docker volume rm"

docker_enter() {
  #if [ -e $(dirname "$0")/nsenter ]; then
  #Change for centos bash running
  if [ -e $(dirname '$0')/nsenter ]; then
    # with boot2docker, nsenter is not in the PATH but it is in the same folder
    NSENTER=$(dirname "$0")/nsenter
  else
    # if nsenter has already been installed with path notified, here will be clarified
    NSENTER=$(which nsenter)
    #NSENTER=nsenter
  fi
  [ -z "$NSENTER" ] && echo "WARN Cannot find nsenter" && return

  if [ -z "$1" ]; then
    echo "Usage: `basename "$0"` CONTAINER [COMMAND [ARG]...]"
    echo ""
    echo "Enters the Docker CONTAINER and executes the specified COMMAND."
    echo "If COMMAND is not specified, runs an interactive shell in CONTAINER."
  else
    PID=$(sudo docker inspect --format "{{.State.Pid}}" "$1")
    if [ -z "$PID" ]; then
      echo "WARN Cannot find the given container"
      return
    fi
    shift

    OPTS="--target $PID --mount --uts --ipc --net --pid"

    if [ -z "$1" ]; then
      # No command given.
      # Use su to clear all host environment variables except for TERM,
      # initialize the environment variables HOME, SHELL, USER, LOGNAME, PATH,
      # and start a login shell.
      #sudo $NSENTER "$OPTS" su - root
      sudo $NSENTER --target $PID --mount --uts --ipc --net --pid su - root
    else
      # Use env to clear all host environment variables.
      sudo $NSENTER --target $PID --mount --uts --ipc --net --pid env -i $@
    fi
  fi
}

docker_rm_regex() {
  docker ps -a --filter name=$1 -aq | xargs docker stop | xargs docker rm
}

docker_rmi_regex() {
  docker images | grep $1 |  xargs docker rmi
}
