export PATH=~/.rbenv/shims:/usr/local/bin:./node_modules/.bin:/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH
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
  zgen oh-my-zsh plugins/command-not-found
  zgen oh-my-zsh plugins/n
  zgen oh-my-zsh plugins/mvn
  zgen oh-my-zsh plugins/virtualenv
  zgen oh-my-zsh plugins/marked2

  # history, syntax highlighting
  # NOTE if zsh-syntax-highlighting is bundled after zsh-history-substring-search, they break, so get the order right.
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search

  # completions
  zgen load zsh-users/zsh-completions src

  # pure theme (async)
  zgen load mafredri/zsh-async
  zgen load sindresorhus/pure

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

# vagrant & vmware fusion
export VAGRANT_DEFAULT_PROVIDER=vmware_fusion

# checkstyle
alias checkstyle-report="ag --before=5 severity=\\\"error **/target/checkstyle-result.xml"

# node stuff
alias nuke_modules="rm -rf node_modules; npm install; npm prune"

# lunchy
LUNCHY_DIR=$(dirname `gem which lunchy`)/../extras
if [ -f $LUNCHY_DIR/lunchy-completion.zsh ]; then
  . $LUNCHY_DIR/lunchy-completion.zsh
fi

# use JDK8 as default
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# GPGTools launches gpg-agent, we'll have to let SSH know we want to use gpg-agent as ssh-agent
if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
fi

# Timings integration
DISABLE_AUTO_TITLE="true"
PROMPT_TITLE='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
export PROMPT_COMMAND="${PROMPT_COMMAND} ${PROMPT_TITLE};"

# Node, n and avn
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn
export N_PREFIX="$HOME/.n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# What the
eval "$(thefuck --alias fu)"

# Update all the things
alias update-casks="brew cask outdated --greedy --verbose | grep -v \"(latest)\" | cut -f1 -d\" \" | xargs brew cask reinstall"
alias update="softwareupdate --install --all; brew update; brew upgrade; update-casks; brew cleanup -s; brew cask cleanup; brew prune"

# Pimp
alias ls="exa"
alias cat="ccat"
alias top="htop"
