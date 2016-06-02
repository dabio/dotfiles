# To enable shims and autocompletion for rbenv.
status --is-interactive; and . (rbenv init -|psub)

set -x GOPATH $HOME/Sites/go
set -x HOMEBREW_CASK_OPTS --appdir=$HOME/Applications

# aliases
alias uuidgen 'uuidgen | tr "[:upper:]" "[:lower:]"'
