# To enable shims and autocompletion for rbenv.
status --is-interactive; and . (rbenv init -|psub)

# Postgres
set -x PATH $PATH /Applications/Postgres.app/Contents/Versions/latest/bin
set -x GOPATH $HOME/Sites/go
set -x HOMEBREW_CASK_OPTS --appdir=$HOME/Applications
set -x EDITOR /usr/bin/vim
set -x HOMESHICK_DIR /usr/local/opt/homeshick

# aliases
alias uuidgen 'uuidgen | tr "[:upper:]" "[:lower:]"'

# gnupg
source $HOME/.config/fish/gnupg.fish

# homeshick
source /usr/local/opt/homeshick/homeshick.fish
