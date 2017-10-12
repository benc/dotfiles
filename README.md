# Dotfiles

See [http://dotfiles.github.io/]()

## Installation

I have:

* OSX
* [Homebrew](http://mxcl.github.com/homebrew/)
* [ZSH](http://www.zsh.org/) + [zgen](https://github.com/tarjoilija/zgen)

Install:

    # install latest ruby
    brew install rbenv
    rbenv install 2.4.2 # or the most recent version
    rbenv global 2.4.2
    gem install lunchy terminal-notifier
    brew install zsh zplug
    git clone https://github.com/benc/dotfiles.git ~/.dotfiles
    brew tap thoughtbot/formulae
    brew install rcm
    rcup rcrc; rcup
    zplug update; zplug load

    # vscode settings need a separate installation until https://github.com/thoughtbot/rcm/issues/135 is resolved
    ~/.dotfiles/setup_vscode

    # install tower settings
    ~/.dotfiles/setup_tower

    # install tooling using brew
    cd ~/.dotfiles/homebrew; brew bundle

    # make sure iTerms shell is set to /usr/local/bin/zsh instead of "Login shell"
