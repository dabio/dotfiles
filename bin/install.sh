#!/usr/bin/env bash
set -e

# install.sh
#	This script installs my basic setup for a mac laptop

USERNAME=$(echo $USER)

# Versions
PACK="0.2.3"

check_is_sudo() {
    CAN_RUN_SUDO=$(sudo -n uptime 2>&1 | grep "load" | wc -l)
    if [ ${CAN_RUN_SUDO} -eq 0 ]; then
        echo "Please run as root."
        exit
    fi
}

# sets up brew
setup_brew() {
    # installs command line tools
    local status=$(xcode-select -p)
    if [ "$status" -eq "$status" ] 2> /dev/null; then
        xcode-select --install
    fi

    if ! hash brew 2>/dev/null ; then
        # install homebrew https://brew.sh
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        find /usr/local -type d -depth 1 -exec chown -R dan:staff {} \;
    fi

    brew doctor
    brew analytics off
    brew update
    brew upgrade

    brew install \
        dep \
        direnv \
        fish \
        go \
        gopass \
        mas \
        p7zip \
        python3 \
        tig \
        trash \
        unrar

    brew cask install \
        appzapper \
        firefox \
        flux \
        spectacle \
        spotify \
        sublime-text

#    brew tap caskroom/fonts
#    brew cask install font-source-code-pro

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

    # atom
#    apm login
#    apm stars --install

#    mas install \
#        `#973049011 # secrets`   \
#        `#409183694 # Keynote`  \
#        409201541 `# Pages`     \
#        409203825 `# Numbers`   \
#        418138339 `# HTTP Client`
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

    # imports the gpg keys
    gpg --import "/Users/dan/Library/Mobile Documents/com~apple~CloudDocs/keys/gpg/gpg.asc"
    # copy ssh keys
    if [ ! -d "${HOME}/.ssh" ]; then
        cp -R "/Users/dan/Library/Mobile Documents/com~apple~CloudDocs/keys/ssh/" ~/.ssh
    fi
    )
}

install_vim() {
    # create subshell
    (
    cd "$HOME"

    ln -snf "${HOME}/.vim/vimrc" "${HOME}/.vimrc"

    #gem install --install-dir /Users/dan/.gem/ruby/2.3.0 neovim
    #pip3 install --user --upgrade neovim
    #/usr/bin/easy_install --user pip
    #${HOME}/Library/Python/2.7/bin/pip2 install --user --upgrade neovim

    # alias vim dotfiles to neovim
    #mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
    #ln -snf "${HOME}/.vim" "${XDG_CONFIG_HOME}/nvim"
    #ln -snf "${HOME}/.vimrc" "${XDG_CONFIG_HOME}/nvim/init.vim"

    if ! hash pack 2>/dev/null ; then
        curl -L https://github.com/maralla/pack/releases/download/v${PACK}/pack-v${PACK}-x86_64-apple-darwin.tar.gz | tar xz
        rm README.md
        mv pack ${HOME}/.dotfiles/bin
        ln -snf ${HOME}/.dotfiles/bin/pack /usr/local/bin/pack
    fi
    pack install
    )
}

install_pip() {
    # create subshell
    (
    # check if pip3 is installed
    if ! hash pip3 2>/dev/null ; then
        echo "Please run 'install.sh brew' to install python3 dependencies first."
        exit
    fi

    pip3 install --user \
        awscli

    )
}

usage() {
    echo -e "install.sh\n\tThis script installs my basic setup for a mac laptop\n"
    echo "Usage:"
    echo "  all         - do everything"
    echo "  brew        - setup homebrew & install base pkgs"
    echo "  dotfiles    - get dotfiles"
    echo "  pip         - install pip packages"
    echo "  vim         - install vim"
}

main() {
    local cmd=$1
    if [[ -z "$cmd" ]]; then
        usage
        exit 1
    fi

    if [[ $cmd == "all" ]]; then
        setup_brew
        get_dotfiles
        install_vim
        install_pip
    elif [[ $cmd == "brew" ]]; then
        setup_brew
    elif [[ $cmd == "dotfiles" ]]; then
        get_dotfiles
    elif [[ $cmd == "pip" ]]; then
        install_pip
    elif [[ $cmd == "vim" ]]; then
        install_vim
    fi
}

main "$@"
