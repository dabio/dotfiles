#!/bin/sh -e

main() {
  test -n "$1" || usage

  case $1 in
    "brew")
      brew_packages
      ;;
    "hardening")
      hardening
      ;;
    "dotfiles")
      dotfiles
      ;;
  esac
}

setup_brew() {
  if ! hash brew 2> /dev/null; then
    local is_admin=$(dseditgroup -o checkmember -m ${USER} admin)
    if echo "$is_admin" | grep -q 'NOT a member'; then
      echo "add user ${USER} to group admin"
      sudo dseditgroup -o edit -a ${USER} -t user admin
    fi

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    find /usr/local -type d -depth 1 -exec chown -R dan:staff {} \;

    if echo "$is_admin" | grep -q 'NOT a member'; then
      echo "remove user ${USER} from group admin"
      sudo dseditgroup -o edit -d ${USER} -t user admin
    fi
  fi

  brew doctor
  brew analytics off
  brew update

  echo "🎉 brew install successful"
}

brew_packages() {
  setup_brew

  brew install \
    direnv \
    go \
    pass \
    terraform \
    tig \
    volt

  brew cask install \
    appzapper \
    flux \
    spotify \
    sublime-text \
    vscodium

  # cleanup
  brew cleanup -s
  rm -fr $(brew --cache)

  echo "🎉 brew packages install successful"
}

hardening() {
  local name=$(uuidgen | tr "[:upper:]" "[:lower:]" | cut -d'-' -f1)
  # set random hostname
  sudo scutil --set HostName ${name}
  sudo scutil --set LocalHostName ${name}
  sudo scutil --set ComputerName ${name}
  dscacheutil -flushcache

  # enable firewall
  sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
  sudo launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist
  sudo launchctl load /System/Library/LaunchAgents/com.apple.alf.useragent.plist

  # block everything
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on

  # set dns server
  networksetup -setdnsservers Wi-Fi Empty
  networksetup -setdnsservers Wi-Fi 1.1.1.1 8.8.8.8

  # disable crash reporter
  sudo defaults write com.apple.CrashReporter DialogType none

  echo "🎉 system hardened. don't forget to reboot"
}

dotfiles() {
  local dir=~/.dotfiles

  if ! test -d "$dir"; then
    git clone https://github.com/dabio/dotfiles.git $dir
  fi

  cd $dir
  git submodule init
  git submodule update
  make
  cd

  # symlink icloud
  test -d ~/icloud || ln -s "~/Library/Mobile Documents/com~apple~CloudDocs" ~/icloud

  # import ssh keys
  test -d ~/.ssh || cp -R ~/icloud/keys/ssh ~/.ssh

  # import gpg keys
  gpg --import ~/icloud/keys/gpg/gpg.asc

  # passwords
  test -d ~/.password-store || gopass clone git@bitbucket.org:danilo/pass.git

  # vim
  ln -snf ~/.vim/vimrc ~/.vimrc

  echo "🎉 dotfiles setup successful"
}

usage() {
  echo "install.sh"
  echo "  This script installs my basic setup for a mac laptop"
  echo
  echo "Usage:"
  echo "  all         - do everything"
  echo "  brew        - setup homebrew & install base pkgs"
  # echo "  shell       - setup the fish shell"
  echo "  dotfiles    - get dotfiles"
  # echo "  python      - install pyenv and other python utilities"
  echo "  hardening   - hardening macOS"
  exit 1
}

main "$@"
