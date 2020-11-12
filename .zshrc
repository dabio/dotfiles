# enable the default zsh completions!
autoload -Uz compinit && compinit

path+=(/usr/local/sbin)
path+=(~/.local/bin)
path+=(~/go/bin)

[[ -d /Applications/Postgres.app/Contents/Versions/latest/bin ]] && path+=(/Applications/Postgres.app/Contents/Versions/latest/bin)

export EDITOR=vim
export VOLTPATH=~/.vim/volt
export GOPATH=~/go
export LC_ALL=en_US.UTF-8
export PYTHONDONTWRITEBYTECODE=1

alias ll="ls -la"
alias pass=gopass
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias cpu="sysctl -n machdep.cpu.brand_string"
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

eval "$(direnv hook zsh)"
# chruby
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
