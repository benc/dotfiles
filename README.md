# Dotfiles

See [http://dotfiles.github.io/]()

## Installation

I have:

* OSX
* [Homebrew](http://mxcl.github.com/homebrew/)
* [ZSH](http://www.zsh.org/) + [zgen](https://github.com/tarjoilija/zgen)

Install:

    brew install zsh
    # configure zsh as your default shell
    git clone https://github.com/benc/dotfiles.git ~/.dotfiles
    brew tap thoughtbot/formulae
    brew install rcm
    rcup rcrc; and rcup
    # vscode settings need a separate installation until https://github.com/thoughtbot/rcm/issues/135 is resolved
    ./dotfiles/setup_vscode
