#!/usr/bin/env bash
set -e

# install.sh
#	This script installs my basic setup for a mac laptop

USERNAME=$(echo $USER)

check_is_sudo() {
    CAN_RUN_SUDO=$(sudo -n uptime 2>&1 | grep "load" | wc -l)
    if [ ${CAN_RUN_SUDO} -eq 0 ]; then
        echo "Please run as root."
        exit
    fi
}

# sets up brew
setup_sources() {
    # installs command line tools
    local status=$(xcode-select -p)
    if [ "$status" -eq "$status" ] 2> /dev/null; then
        xcode-select --install
    fi

    if ! hash brew 2>/dev/null ; then
        # install homebrew https://brew.sh
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew doctor
    brew update
}

base() {
    brew analytics off
    brew update
    brew upgrade

    brew install \
        go \
        dep \
        gopass \
        tig \
        fish \
        unrar \
        p7zip \
        trash \
        mas \
        neovim \
        direnv \
        the_silver_searcher

    brew cask install appzapper \
        firefox \
        spotify \
        sublime-text \
        spectacle \
        flux \
        keybase

    brew tap caskroom/fonts
    brew cask install font-source-code-pro

    # activate fish
    if ! grep -Fxq "$(brew --prefix)/bin/fish" /etc/shells; then
        echo "$(brew --prefix)/bin/fish" | sudo tee -a /etc/shells > /dev/null
    fi
    # iterm2
    #if [ ! -f "${HOME}/.config/fish/startup.fish" ]; then
    #    curl -fLo "${HOME}/.config/fish/startup.fish" --create-dirs \
    #        "https://iterm2.com/misc/fish_startup.in"
    #fi
    chsh -s $(brew --prefix)/bin/fish

    mas install \
        `#973049011 # secrets`   \
        `#409183694 # Keynote`  \
        409201541 `# Pages`     \
        409203825 `# Numbers`   \
        418138339 `# HTTP Client`
}

get_dotfiles() {
    # create subshell
    (
    cd "$HOME"

    if [ ! -d "${HOME}/.dotfiles" ]; then
        # install dotfiles from repo
        git clone \
            https://github.com/dabio/dotfiles.git \
            "${HOME}/.dotfiles"
    fi
    cd "${HOME}/.dotfiles"

    # installs all the things
    make
    )
}

install_vim() {
    # create subshell
    (
    cd "$HOME"

    ln -snf "${HOME}/.vim/vimrc" "${HOME}/.vimrc"

    gem install --install-dir /Users/dan/.gem/ruby/2.3.0 neovim

    # alias vim dotfiles to neovim
    mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
    ln -snf "${HOME}/.vim" "${XDG_CONFIG_HOME}/nvim"
    ln -snf "${HOME}/.vimrc" "${XDG_CONFIG_HOME}/nvim/init.vim"

    curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    )
}

install_alacritty() {
    # create subshell
    (
    printf "Installing alacritty"
    # install tmux
    if ! hash tmux 2>/dev/null ; then
        brew install tmux
    fi
    # install rustup
    if ! hash rustup-init 2>/dev/null ; then
        brew install rustup-init
    fi
    # install rust
    if ! hash cargo 2>/dev/null ; then
        rustup-init --no-modify-path
    fi

    source ~/.config/fish/config.fish

    git clone https://github.com/jwilm/alacritty.git /tmp/alacritty
    cd /tmp/alacritty
    rustup override set stable
    rustup update stable
    cargo build --release
    make app
    sudo cp -r target/release/osx/Alacritty.app /Applications/

    printf "Alacritty installation finished"
    )
}

usage() {
    echo -e "install.sh\n\tThis script installs my basic setup for a mac laptop\n"
    echo "Usage:"
    echo "  sources     - setup sources & install base pkgs"
    echo "  dotfiles    - get dotfiles"
    echo "  terminal    - install alacritty terminal"
    echo "  vim         - install vim"
}

main() {
    local cmd=$1
    if [[ -z "$cmd" ]]; then
        usage
        exit 1
    fi

    if [[ $cmd == "sources" ]]; then
        setup_sources
        base
    elif [[ $cmd == "dotfiles" ]]; then
        get_dotfiles
    elif [[ $cmd == "terminal" ]]; then
        install_alacritty
    elif [[ $cmd == "vim" ]]; then
        install_vim
    fi
}

main "$@"
