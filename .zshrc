# enable the default zsh completions!
autoload -Uz compinit && compinit

path+=(/usr/local/sbin)
path+=(~/.local/bin)
path+=(~/go/bin)

export EDITOR=vim
export VOLTPATH=~/.vim/volt
export GOPATH=~/go
export LC_ALL=en_US.UTF-8

alias ll="ls -la"
alias pass=gopass
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias cpu="sysctl -n machdep.cpu.brand_string"
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'

eval "$(direnv hook zsh)"
