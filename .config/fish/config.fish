source ~/.config/fish/aliases.fish

if status --is-login

    set -x PATH $PATH $HOME/.local/bin

    # Postgres
    if test -d /Applications/Postgres.app/Contents/Versions/latest/bin
        set -x PATH $PATH /Applications/Postgres.app/Contents/Versions/latest/bin
    end

    # go
    set -x GOPATH $HOME/go
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

    # python3
    #    if test -d $HOME/Library/Python/3.7/bin
    #        set -x PATH $PATH $HOME/Library/Python/3.7/bin
    #    end
    # pyenv
    if command --search pyenv > /dev/null do
        source (pyenv init -|psub)
    end
    # poetry
    if test -d $HOME/.poetry/bin
        set -x PATH $PATH $HOME/.poetry/bin
        source $HOME/.poetry/env
    end

    if test -L /usr/local/bin/vim
        set -x EDITOR /usr/local/bin/vim
    else
        set -x EDITOR /usr/bin/vim
    end

    # trash
    if command --search trash > /dev/null do
        alias rm "trash"
    end

    if status --is-interactive
        eval sh $HOME/.dotfiles/.config/base16-shell/scripts/base16-default-dark.sh
    end

    # Don't write bytecode, Python!
    set PYTHONDONTWRITEBYTECODE 1

    # direnv
    eval (direnv hook fish)
end

export GPG_TTY=(tty)
