export RBENV_ROOT=$HOME/.rbenv
export PATH=/usr/local/bin:./node_modules/.bin:/Applications/Postgres.app/Contents/Versions/9.5/bin:$PATH

source "$HOME/.dotfiles/zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
  echo "Creating a zgen save"

  # plugins
  zgen oh-my-zsh

  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/z
  zgen oh-my-zsh plugins/bgnotify

  zgen oh-my-zsh plugins/rbenv
  # zgen oh-my-zsh plugins/bundler
  # zgen oh-my-zsh plugins/gem
  # zgen oh-my-zsh plugins/rake
  # zgen oh-my-zsh plugins/rake-fast
  # zgen oh-my-zsh plugins/ruby

  zgen oh-my-zsh plugins/nvm
  # zgen oh-my-zsh plugins/bower
  # zgen oh-my-zsh plugins/gulp

  # zgen oh-my-zsh plugins/spring
  zgen oh-my-zsh plugins/mvn
  # zgen oh-my-zsh plugins/scala

  # zgen oh-my-zsh plugins/bbedit
  zgen oh-my-zsh plugins/sublime
  # zgen oh-my-zsh plugins/marked2
  # zgen oh-my-zsh plugins/forklift

  zgen oh-my-zsh plugins/vagrant
  zgen oh-my-zsh plugins/aws

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

  # a zsh plugin to help remembering those aliases you once defined
  zgen load djui/alias-tips

  # fish like autosuggestions - should be loaded last
  zgen load tarruda/zsh-autosuggestions

  # save all to init script
  zgen save
fi

export EDITOR=code

# link up with iterm2
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# history substring search: bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Enable autosuggestions automatically.
# zle -N zle-line-init autosuggest_start

# phantomjs
export PHANTOMJS_BIN=/usr/local/bin/phantomjs

# vagrant
export VAGRANT_DEFAULT_PROVIDER=vmware_fusion

# checkstyle
alias checkstyle-report="ag --before=5 severity=\\\"error **/target/checkstyle-result.xml"

# node stuff
alias nuke_modules="rm -rf node_modules; npm install; npm prune"
