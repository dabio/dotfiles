#!/bin/bash
set -e

# install.sh
#	This script installs my basic setup for a mac laptop

USERNAME=$(echo $USER)
# Update to newer python version in vimrc as well
PYTHON2=2.7.13
PYTHON3=3.6.0

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
    xcode-select --install

    # install homebrew https://brew.sh
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    brew doctor
    brew update
}

base() {
    brew analytics off
    #brew doctor
    brew update

    brew install bash-completion \
        go \
        tig \
        heroku-toolbelt \
        fish \
        unrar \
        p7zip \
        trash \
        gnupg2 \
        mas \
        docker \
        docker-compose

    brew cask install appzapper \
        firefox \
        flux \
        iterm2 \
        spotify \
        sublime-text

    brew install neovim/neovim/neovim

    brew tap caskroom/fonts
    brew cask install font-source-code-pro

    brew tap justwatchcom/gopass
    brew install gopass

    mas install 973049011 \ # secrets
        409183694 \         # Keynote
        409201541 \         # Pages
        409203825 \         # Numbers
        418138339           # HTTP Client

    # activate fish
    if ! grep -Fxq "$(brew --prefix)/bin/fish" /etc/shells; then
        echo "$(brew --prefix)/bin/fish" | sudo tee -a /etc/shells > /dev/null
    fi
    if [ ! -f "${HOME}/.config/fish/startup.fish" ]; then
        curl -fLo "${HOME}/.config/fish/startup.fish" --create-dirs \
            "https://iterm2.com/misc/fish_startup.in"
    fi
    chsh -s $(brew --prefix)/bin/fish
}

get_dotfiles() {
	# create subshell
	(
	cd "$HOME"

	# install dotfiles from repo
	#git clone https://github.com/dabio/dotfiles.git "${HOME}/.dotfiles"
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

	# alias vim dotfiles to neovim
	mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
	ln -snf "${HOME}/.vim" "${XDG_CONFIG_HOME}/nvim"
	ln -snf "${HOME}/.vimrc" "${XDG_CONFIG_HOME}/nvim/init.vim"

    ln -snf "/usr/local/bin/nvim" "/usr/local/bin/vim"
    ln -snf "/usr/local/bin/nvim" "/usr/local/bin/vi"

    brew install pyenv pyenv-virtualenv

    # Python2
    if [ ! -d "$(pyenv root)/versions/${PYTHON2}" ]; then
        pyenv install ${PYTHON2}
    fi
    if [ ! -d "$(pyenv root)/versions/${PYTHON2}/envs/neovim2" ]; then
        pyenv virtualenv ${PYTHON2} neovim2
    fi
    source "$(pyenv root)/versions/neovim2/bin/activate"
    pip install neovim
    deactivate

    # Python3
    if [ ! -d "$(pyenv root)/versions/${PYTHON3}" ]; then
        pyenv install ${PYTHON3}
    fi
    if [ ! -d "$(pyenv root)/versions/${PYTHON3}/envs/neovim3" ]; then
        pyenv virtualenv ${PYTHON3} neovim3
    fi
    source "$(pyenv root)/versions/neovim3/bin/activate"
    pip install neovim
    deactivate

    sudo gem install neovim

	curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
		"https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	)

    curl -fLo "${HOME}/.vim/colors/base16-tomorrow-night.vim" --create-dirs \
        "https://raw.githubusercontent.com/chriskempson/base16-vim/master/colors/base16-tomorrow-night.vim"
}

usage() {
	echo -e "install.sh\n\tThis script installs my basic setup for a mac laptop\n"
	echo "Usage:"
	echo "  sources     - setup sources & install base pkgs"
	echo "  dotfiles    - get dotfiles"
	echo "  vim         - install vim"
}

main() {
	local cmd=$1
	if [[ -z "$cmd" ]]; then
		usage
		exit 1
	fi

    if [[ $cmd == "sources" ]]; then
        #setup_sources
        base
    elif [[ $cmd == "dotfiles" ]]; then
		get_dotfiles
	elif [[ $cmd == "vim" ]]; then
		install_vim
	fi
}

main "$@"
