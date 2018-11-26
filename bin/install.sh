#!/bin/bash

# Version definitions
PACK="0.2.3"
PYTHON_VERSIONS=("3.7.1")

setup_brew() {
  (
  # Homebrew does that by itself now
  #local status=$(xcode-select -p)
  #if [ "$status" -eq "$status" ] 2> /dev/null; then
  #  xcode-select --install
  #fi

  if ! hash brew 2> /dev/null; then
    local is_admin="$(dseditgroup -o checkmember -m ${USER} admin)"
    if [[ "${is_admin}" == *"NOT a member"* ]]; then
      sudo dseditgroup -o edit -a ${USER} -t user admin
      echo "add user ${USER} to group admin"
    fi

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    find /usr/local -type d -depth 1 -exec chown -R dan:staff {} \;

    if [[ ${is_admin} == *"NOT a member"* ]]; then
      sudo dseditgroup -o edit -d ${USER} -t user admin
      echo "remove user ${USER} from group admin"
    fi
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
    terraform \
    tig \
    trash \
    tmux \
    unrar \
    vim

  brew cask install \
    appzapper \
    firefox \
    flux \
    spectacle \
    spotify \
    sublime-text

  # cleanup
  brew cleanup -s
  rm -fr $(brew --cache)

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
  curl -L https://github.com/maralla/pack/releases/download/v${PACK}/pack-v${PACK}-x86_64-apple-darwin.tar.gz | tar xz
  rm README.md
  mv pack ${HOME}/.dotfiles/bin
  ln -snf ${HOME}/.dotfiles/bin/pack /usr/local/bin/pack
  pack install
}

dotfiles() {
  (
  local dotfiles_dir="${HOME}/.dotfiles"

  if ! test -d "${dotfiles_dir}"; then
    git clone https://github.com/dabio/dotfiles.git "${dotfiles_dir}"
  fi

  cd "${dotfiles_dir}"
  git submodule init
  git submodule update
  make
  cd "${HOME}"

  # symlink icloud
  ln -s ${HOME}/Library/Mobile\ Documents/com~apple~CloudDocs ${HOME}/iCloud

  # import gpg secrets
  if test -d "${HOME}/iCloud/keys/gpg"; then
    gpg --import "${HOME}/iCloud/keys/gpg/gpg.asc"
  fi

  # import ssh keys
  if ! test -d "${HOME}/.ssh"; then
    cp -R "${HOME}/iCloud/keys/ssh/" ~/.ssh
  fi
  # update permissions of ~/.ssh folder
  chmod 0700 ~/.ssh
  chmod 0600 ~/.ssh/id_rsa
  chmod 0644 ~/.ssh/id_rsa.pub

  # gopass
  if ! test -d "${HOME}/.password-store"; then
    gopass clone git@bitbucket.org:danilo/pass.git
  fi

  # VIM

  ln -snf "${HOME}/.vim/vimrc" "${HOME}/.vimrc"

  if ! hash pack 2>/dev/null; then
    install_pack
  fi

  if test "${PACK}" != "$(pack --version | cut -d' ' -f2)"; then
    install_pack
  fi

  pack update

  echo "🎉 dotfiles setup successful"
  )
}

python_setup() {
  (
  # install pyenv and
  brew install pyenv \
      openssl \
      readline \
      sqlite \
      xz \
      zlib
  # install headers
  sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /

  # install python versions
  for v in "${PYTHON_VERSIONS[@]}"; do
    if ! test -d "$(pyenv root)/versions/$v"; then
      pyenv install $v
    fi
    pyenv global $v
  done

  # install poetry
  if ! test -d "$HOME/.poetry/bin"; then
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
    mkdir -p ~/.config/fish/completions
    $HOME/.poetry/bin/poetry completions fish > ~/.config/fish/completions/poetry.fish
    # create virtualenvs in project directory
    $HOME/.poetry/bin/poetry config settings.virtualenvs.in-project true
  fi
  poetry self:update

  echo "🎉 python setup successful"
  )
}

hardening() {
    (
    local name=$(uuidgen | tr "[:upper:]" "[:lower:]" | cut -d'-' -f1)
    # set random hostname
    sudo scutil --set HostName ${name}
    sudo scutil --set LocalHostName ${name}
    sudo scutil --set ComputerName ${name}
    dscacheutil -flushcache

    # enable firewall
    sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
    sudo launchctl unload /System/Library/LaunchAgents/com.apple.alf.useragent.plist
    sudo launchctl unload /System/Library/LaunchDaemons/com.apple.alf.agent.plist
    sudo launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist
    sudo launchctl load /System/Library/LaunchAgents/com.apple.alf.useragent.plist

    # block everything
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on

    # set dns server
    networksetup -setdnsservers Wi-Fi Empty
    networksetup -setdnsservers Wi-Fi 1.1.1.1 8.8.8.8

    # disable captive portal
    #sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

    # disable crash reporter
    sudo defaults write com.apple.CrashReporter DialogType none
    )
}

usage() {
  echo -e "install.sh\n\tThis script installs my basic setup for a mac laptop\n"
  echo "Usage:"
  echo "  all         - do everything"
  echo "  brew        - setup homebrew & install base pkgs"
  echo "  shell       - setup the fish shell"
  echo "  dotfiles    - get dotfiles"
  echo "  python      - install pyenv and other python utilities"
  echo "  hardening   - hardening macOS"
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
      hardening
      python_setup
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
    "hardening")
      hardening
      ;;
    "python")
      python_setup
      ;;
    *)
      usage
      ;;
  esac
}

main "$@"
