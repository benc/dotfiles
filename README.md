# Dotfiles

## Installation

### Prerequisites

* macos
* [XCode](https://developer.apple.com/xcode/) or [XCode Command Line Tools](https://developer.apple.com/download/more/)
* [Homebrew](http://mxcl.github.com/homebrew/)
* [ZSH](http://www.zsh.org/) + [zgen](https://github.com/tarjoilija/zgen)

### dotfiles

    # get dotfiles, and install
    git clone https://github.com/benc/dotfiles.git ~/.dotfiles
    brew tap thoughtbot/formulae
    brew install rcm
    rcup rcrc; rcup

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

    # after installation of zshell,  make sure iTerms shell is set to /usr/local/bin/zsh instead of "Login shell"
    # then, open a new terminal to initialize zplug
    cd ~/.dotfiles/homebrew/server; brew bundle install

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

* Java 8 is standard
* `checkstyle-report`

#### Ruby development

[`rbenv`](https://github.com/rbenv/rbenv)

#### Node development

* [`n`](https://github.com/tj/n) + [`avn`](https://github.com/wbyoung/avn)
* Everything in `./node_modules/.bin/` is accessible in the terminal
