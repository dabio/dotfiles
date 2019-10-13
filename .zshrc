path+=(/usr/local/sbin)
path+=(~/.local/bin)

export EDITOR=vim
export VOLTPATH=~/.vim/volt

alias ll="ls -la"
alias pass=gopass
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias cpu="sysctl -n machdep.cpu.brand_string"
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'

eval "$(direnv hook zsh)"
