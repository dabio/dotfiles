# To enable shims and autocompletion for rbenv.
set PATH $HOME/.rbenv/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
rbenv rehash > /dev/null ^&1

set -x GOPATH $HOME/Sites/go

# aliases
alias uuidgen 'uuidgen | tr "[:upper:]" "[:lower:]"'
