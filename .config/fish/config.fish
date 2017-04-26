# To enable shims and autocompletion for rbenv.
status --is-interactive; and . (rbenv init -|psub)

# Postgres
set -x PATH $PATH /Applications/Postgres.app/Contents/Versions/latest/bin

# go
set -x GOPATH $HOME/Sites/go
set -x PATH $PATH $GOPATH/bin

# Homebrew
set -x HOMEBREW_CASK_OPTS --appdir=$HOME/Applications

set -x EDITOR /usr/local/bin/nvim
set -x HOMESHICK_DIR /usr/local/opt/homeshick
set -x DOCKER_API_VERSION 1.22

# direnv
eval (direnv hook fish)

# aliases
alias uuidgen 'uuidgen | tr "[:upper:]" "[:lower:]"'

# gnupg
source $HOME/.config/fish/gnupg.fish

# homeshick
source /usr/local/opt/homeshick/homeshick.fish

# iterm2
source $HOME/.config/fish/startup.fish