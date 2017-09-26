# dabio's Dotfiles

These are my dotfiles. Use them as you like! 

## Start from Scratch

Get sudo access. Get ssh keys into correct directory.

    $ # installs the developer tools
    $ sudo xcodebuild -license
    $ # install homebrew
    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    $ # change owner of homebrew directory
    $ sudo chown -R dan:staff /usr/local
    $ brew doctor && brew doctor
    $ cd /Users/dan && git clone https://github.com/dabio/dotfiles.git .dotfiles
    $ cd /Users/dan/.dotfiles
    $ make
    $ install.sh sources
    $ install.sh vim
