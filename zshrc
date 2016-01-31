export RBENV_ROOT=$HOME/.rbenv
export PATH=/usr/local/bin:/Applications/Postgres.app/Contents/Versions/9.5/bin:$PATH

source "$HOME/.dotfiles/zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
  echo "Creating a zgen save"

  # plugins
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/z
  zgen oh-my-zsh plugins/rbenv
  zgen oh-my-zsh plugins/nvm
  zgen oh-my-zsh plugins/bgnotify
  zgen oh-my-zsh plugins/spring
  zgen oh-my-zsh plugins/sublime
  zgen oh-my-zsh plugins/vagrant

  # history, syntax highlighting
  # NOTE if zsh-syntax-highlighting is bundled after zsh-history-substring-search, they break, so get the order right.
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search

  # completions
  zgen load zsh-users/zsh-completions src

  # pure theme (async)
  zgen load mafredri/zsh-async
  zgen load sindresorhus/pure

  # k is a zsh script / plugin to make directory listings more readable,
  # adding a bit of color and some git status information on files and directories
  zgen load rimraf/k

  # a next-generation cd command with an interactive filter
  # zgen load b4b4r07/enhancd

  # automatically run zgen update and zgen selfupdate every 7 days
  zgen load unixorn/autoupdate-zgen

  # a zsh plugin to help remembering those aliases you once defined
  zgen load djui/alias-tips

  # fish like autosuggestions - should be loaded last
  # zgen load tarruda/zsh-autosuggestions
  zgen load tarruda/zsh-autosuggestions.git . v0.1.x

  # save all to init script
  zgen save
fi

export EDITOR=subl

# link up with iterm2
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# vscode
alias code="/Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron"

# history substring search: bind UP and DOWN arrow keys
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# Enable autosuggestions automatically.
zle -N zle-line-init autosuggest_start

# phantomjs
export PHANTOMJS_BIN=/opt/phantomjs/phantomjs-2.1.1-macosx/bin

# checkstyle
alias checkstyle-report="ag --before=5 severity=\"error **/target/checkstyle-result.xml"