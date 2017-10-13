# Dotfiles

See [http://dotfiles.github.io/]()

## Installation

Prerequisites:

* macos
* [XCode](https://developer.apple.com/xcode/) or [XCode Command Line Tools](https://developer.apple.com/download/more/)
* [Homebrew](http://mxcl.github.com/homebrew/)
* [ZSH](http://www.zsh.org/) + [zgen](https://github.com/tarjoilija/zgen)

Install:

    # get dotfiles, and install
    git clone https://github.com/benc/dotfiles.git ~/.dotfiles
    brew tap thoughtbot/formulae
    brew install rcm
    rcup rcrc; rcup

    # vscode settings need a separate installation until https://github.com/thoughtbot/rcm/issues/135 is resolved
    ~/.dotfiles/setup_vscode

    # install tower settings
    ~/.dotfiles/setup_tower

    # install latest ruby
    brew install rbenv
    rbenv install 2.4.2 # or the most recent version
    rbenv global 2.4.2
    gem install lunchy terminal-notifier

    # install zshell
    brew install zsh zplug

    # after installation of zshell,  make sure iTerms shell is set to /usr/local/bin/zsh instead of "Login shell"
    # then, open a new terminal to initialize zplug

    # install tooling using brew
    # >> choose which collection to install
    cd ~/.dotfiles/homebrew/full; brew bundle install
    cd ~/.dotfiles/homebrew/server; brew bundle install

## Updates

To update the system, use the `update` alias.

[`brew bundle`](https://github.com/Homebrew/homebrew-bundle) is used to manage installations. To update the brewfiles:

    cd ~/.dotfiles/homebrew/full; brew bundle dump --force
    cd ~/.dotfiles/homebrew/server; brew bundle dump --force
