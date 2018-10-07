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
    terraform \
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

  # gopass
  if ! test -d "${HOME}/.password-store"; then
    gopass clone https://danilo@bitbucket.org/danilo/pass.git
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
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

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
    *)
      usage
      ;;
  esac
}

main "$@"
