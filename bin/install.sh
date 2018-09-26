#!/bin/bash

# Version definitions
PACK="0.2.3"

setup_brew() {
  (
  local status=$(xcode-select -p)
  if [ "$status" -eq "$status" ] 2> /dev/null; then
    xcode-select --install
  fi

  if ! hash brew 2> /dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    find /usr/local -type d -depth 1 -exec chown -R dan:staff {} \;
  fi

  brew doctor
  brew analytics off
  brew update
  brew upgrade

  echo "🎉 brew install successful"
  )
}

brew_packages() {
  (
  setup_brew

  brew install \
    direnv \
    fish \
    go \
    gopass \
    mas \
    p7zip \
    python \
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

  echo "🎉 brew packages install successful"
  )
}

setup_shell() {
  (
  # activate fish
  local fish_path="$(brew --prefix)/bin/fish"
  if ! grep -Fxq ${fish_path} /etc/shells; then
    echo $fish_path | sudo tee -a /etc/shells > /dev/null
  fi

  if [[ "${SHELL}" != "${fish_path}" ]]; then
    chsh -s $fish_path
  fi

  echo "🎉 fish shell setup successful"
  )
}

install_pack() {
  curl -L https://github.com/maralla/pack/releases/download/v${PACK}/pack-v${PACK}-x86_64-apple-darwin.tar.gz | tar xz
  rm README.md
  mv pack ${HOME}/.dotfiles/bin
  ln -snf ${HOME}/.dotfiles/bin/pack /usr/local/bin/pack
}

dotfiles() {
  (
  local dotfiles_dir="${HOME}/.dotfiles"

  if ! test -d "${dotfiles_dir}"; then
    git clone https://github.com/dabio/dotfiles.git "${dotfiles_dir}"
  fi

  cd "${dotfiles_dir}"
  make
  cd "${HOME}"

  # import gpg secrets
  if test -d "/Users/dan/Library/Mobile Documents/com~apple~CloudDocs/keys/gpg"; then
    gpg --import "/Users/dan/Library/Mobile Documents/com~apple~CloudDocs/keys/gpg/gpg.asc"
  fi

  # import ssh keys
  if ! test -d "${HOME}/.ssh"; then
    cp -R "/Users/dan/Library/Mobile Documents/com~apple~CloudDocs/keys/ssh/" ~/.ssh
  fi

  # VIM

  ln -snf "${HOME}/.vim/vimrc" "${HOME}/.vimrc"

  if ! hash pack 2>/dev/null; then
    install_pack
  fi

  if [ "${PACK}" != $(pack --version | cut -d' ' -f2) ]; then
    install_pack
  fi

  pack install

  echo "🎉 dotfiles setup successful"
  )
}

usage() {
  echo -e "install.sh\n\tThis script installs my basic setup for a mac laptop\n"
  echo "Usage:"
  echo "  all         - do everything"
  echo "  brew        - setup homebrew & install base pkgs"
  echo "  shell       - setup the fish shell"
  echo "  dotfiles    - get dotfiles"
}

main() {
  local cmd=$1
  if [[ -z "$cmd" ]]; then
    cmd="all"
  fi

  case $cmd in
    "all")
      brew_packages
      setup_shell
      dotfiles
      ;;
    "brew")
      brew_packages
      ;;
    "shell")
      setup_shell
      ;;
    "dotfiles")
      dotfiles
      ;;
    *)
      usage
      ;;
  esac
}

main "$@"
