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

# rust
if test -d $HOME/.cargo/bin
    set -x PATH $PATH $HOME/.cargo/bin
end

status --is-interactive ; and eval sh $HOME/.dotfiles/.config/base16-shell/scripts/base16-default-dark.sh

# MOTD
function echo_color
  printf "\033[0;90m$argv[1]\033[0m\n"
end
echo_color "c-f  Move forward"
echo_color "c-b  Move backward"
echo_color "c-p  Move up"
echo_color "c-n  Move down"
echo_color "c-a  Jump to beginning of line"
echo_color "c-e  Jump to end of line"
echo_color "c-d  Delete forward"
echo_color "c-h  Delete backward"
echo_color "c-k  Delete forward to end of line"
echo_color "c-u  Delete entire line"

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
