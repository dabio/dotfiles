# To enable shims and autocompletion for rbenv.
status --is-interactive; and . (rbenv init -|psub)

set -x GOPATH $HOME/Sites/go

# aliases
alias uuidgen 'uuidgen | tr "[:upper:]" "[:lower:]"'

export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
