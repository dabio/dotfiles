source ~/.config/fish/aliases.fish

if status --is-login

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

    set editor /usr/bin/vim
    # nvim
    if command --search nvim > /dev/null do
        alias vim "nvim"
        alias vi "nvim"
        set editor /usr/local/bin/nvim
    end
    set -x EDITOR $editor

    # trash
    if command --search trash > /dev/null do
        alias rm "trash"
    end

    if status --is-interactive
        eval sh $HOME/.dotfiles/.config/base16-shell/scripts/base16-default-dark.sh
    end

    # Don't write bytecode, Python!
    export PYTHONDONTWRITEBYTECODE=1

    # direnv
    eval (direnv hook fish)
end

export GPG_TTY=(tty)
