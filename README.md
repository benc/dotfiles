# Dotfiles

## Installation

### Prerequisites

* macos
* [XCode](https://developer.apple.com/xcode/) or [XCode Command Line Tools](https://developer.apple.com/download/more/)
* [Homebrew](http://mxcl.github.com/homebrew/)

### dotfiles

    # get dotfiles, and install
    git clone https://github.com/benc/dotfiles.git ~/.dotfiles
    brew tap thoughtbot/formulae
    brew install rcm
    cd ~/.dotfiles/; rcup rcrc; rcup

    # vscode settings need a separate installation until https://github.com/thoughtbot/rcm/issues/135 is resolved
    ~/.dotfiles/setup_vscode

    # install tower settings
    ~/.dotfiles/setup_tower

### tooling

    # install tooling using brew
    # >> choose which collection to install
    cd ~/.dotfiles/homebrew/full; brew bundle install

### zsh

    # install zshell
    brew install zsh zplug

Two options:

* Launch `/usr/local/bin/zsh` in iTerm
* Set as default shell - could be troublesome if zsh gets b0rk3d down the road

        sudo sh -c "echo /usr/local/bin/zsh >> /etc/shells"
        chsh -s /usr/local/bin/zsh

        # fix insecure directory warning
        compaudit | xargs chmod g-w

### python

    brew install readline xz
    curl https://pyenv.run | bash

    brew reinstall bzip2 zlib

    # anaconda
    pyenv install anaconda3-2020.07

    # python 3.7.9
    LDFLAGS="-L$(brew --prefix bzip2)/lib -L$(brew --prefix zlib)/lib" CPPFLAGS="-I$(brew --prefix bzip2)/include -I$(brew --prefix zlib)/include" pyenv install 3.7.9
    mkdir -p $(brew --cellar python@3.7); ln -s ~/.pyenv/versions/3.7.9 $(brew --cellar python@3.7)/3.7.9

    # python 3.8.6
    LDFLAGS="-L$(brew --prefix bzip2)/lib -L$(brew --prefix zlib)/lib" CPPFLAGS="-I$(brew --prefix bzip2)/include -I$(brew --prefix zlib)/include" pyenv install 3.8.6
    mkdir -p $(brew --cellar python@3.8); ln -s ~/.pyenv/versions/3.8.6 $(brew --cellar python@3.8)/3.8.6

    # python 3.9.1
    LDFLAGS="-L$(brew --prefix bzip2)/lib -L$(brew --prefix zlib)/lib" CPPFLAGS="-I$(brew --prefix bzip2)/include -I$(brew --prefix zlib)/include" pyenv install 3.9.1
    mkdir -p $(brew --cellar python@3.9);  ln -s ~/.pyenv/versions/3.9.1 $(brew --cellar python@3.9)/3.9.1
    brew link python3
    pyenv global 3.9.1

    # to install packages into the correct python
    pyenv shell 3.8.6
    python -m pip install --upgrade pip
    python -m pip install pipenv

### ruby

    brew install rbenv
    rbenv install 2.4.2 # or the most recent version
    rbenv global 2.4.2
    gem install lunchy terminal-notifier

### node

    # n is installed using brew, make sure you're using zsh & config at this moment
    npm install -g avn avn-nvm avn-n # run for each node version
    avn setup # run only once

## Usage

### Updates

To update the system, use the `update` alias.

[`brew bundle`](https://github.com/Homebrew/homebrew-bundle) is used to manage installations. To update the brewfiles:

    # >> choose which collection to update
    cd ~/.dotfiles/homebrew/full; brew bundle dump --force
    cd ~/.dotfiles/homebrew/server; brew bundle dump --force

### CLI

#### ZSH, zplug, oh-my-zsh

* `zsh` with completions, syntax highlighting, history search, autosuggestions
* [command not found](https://github.com/Homebrew/homebrew-command-not-found) support
* notifications for long-running commands
* gives suggestions to available aliases when running commands
#### Integrations

* `gpg` as `ssh` (using [GpgTools](https://gpgtools.org/))
* [iTerm2](https://iterm2.com/) ZSH integration
* [Timing 2](https://timingapp.com/) ZSH integration

#### Tooling

* [`fu`](https://github.com/nvbn/thefuck)
* [`z`](https://github.com/rupa/z) with [added](https://github.com/changyuheng/fz) [`fzf`](https://github.com/junegunn/fzf) oomph
* [`up`](https://github.com/shannonmoeller/up)
* `nuke_modules` removes a node_modules dir and reinstalls it
* `update` will update all the things
* `ls` is [exa](https://github.com/ogham/exa)
* `cat` is [ccat](https://github.com/jingweno/ccat)
* `top` is [htop](https://github.com/hishamhm/htop)
* [`fzf`](https://github.com/junegunn/fzf)
* [`ag`](https://github.com/ggreer/the_silver_searcher)

#### Java Development

* Java 11 is standard
* `checkstyle-report`

#### Ruby development

[`rbenv`](https://github.com/rbenv/rbenv)

#### Node development

* [`n`](https://github.com/tj/n) + [`avn`](https://github.com/wbyoung/avn)
* Everything in `./node_modules/.bin/` is accessible in the terminal
