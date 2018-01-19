# To enable shims and autocompletion for rbenv.
#status --is-interactive; and . (rbenv init -|psub)
#status --is-interactive; and source (nodenv init -|psub)

# Postgres
if test -d /Applications/Postgres.app/Contents/Versions/latest/bin
    set -x PATH $PATH /Applications/Postgres.app/Contents/Versions/latest/bin
end

# go
set -x GOPATH $HOME/Sites/go
if test -d $GOPATH/bin
    set -x PATH $PATH $GOPATH/bin
end

# ruby gems
if test -d $HOME/.gem/ruby/2.3.0/bin
    set -x PATH $PATH $HOME/.gem/ruby/2.3.0/bin
end

status --is-interactive ; and eval sh $HOME/.dotfiles/.config/base16-shell/scripts/base16-default-dark.sh

# Homebrew
#set -x HOMEBREW_CASK_OPTS --appdir=$HOME/Applications

set -x EDITOR /usr/bin/vim
#set -x DOCKER_API_VERSION 1.22

# direnv
eval (direnv hook fish)

# aliases
alias uuidgen 'uuidgen | tr "[:upper:]" "[:lower:]"'

# gnupg
source $HOME/.config/fish/gnupg.fish

# homeshick
#source /usr/local/opt/homeshick/homeshick.fish

# iterm2
#source $HOME/.config/fish/startup.fish
