# enable the default zsh completions!
autoload -Uz compinit && compinit

path+=(~/.local/bin)

# [[ -d /Applications/Postgres.app/Contents/Versions/latest/bin ]] && path+=(/Applications/Postgres.app/Contents/Versions/latest/bin)

export EDITOR=/usr/bin/vim
export VOLTPATH=~/.vim/volt

alias ll="ls -lah"
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'

eval "$(direnv hook zsh)"
