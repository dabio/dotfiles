# enable the default zsh completions!
autoload -Uz compinit && compinit

path+=(~/.local/bin)

# [[ -d /Applications/Postgres.app/Contents/Versions/latest/bin ]] && path+=(/Applications/Postgres.app/Contents/Versions/latest/bin)

export EDITOR=/usr/bin/vim
export VOLTPATH=~/.vim/volt

alias ll="ls -lah"
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'

export SSH_AUTH_SOCK=/Users/dan/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

eval "$(direnv hook zsh)"
