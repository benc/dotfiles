export PATH=~/.rbenv/shims:/usr/local/bin:./node_modules/.bin:/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH
export EDITOR=code

### HISTORY ###
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

### ZPLUG ###
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zplug/zplug", hook-build:"zplug --self-manage"

# plugins
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/bgnotify", from:oh-my-zsh
zplug "plugins/rbenv", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/mvn", from:oh-my-zsh
zplug "lib/spectrum", from:oh-my-zsh # colors

# pure theme (async)
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure", use:pure.zsh, as:theme

# jump around
zplug "changyuheng/fz", defer:1 # needs brew install fzf
zplug "rupa/z", use:z.sh

# jump up
zplug "shannonmoeller/up", use:"up.sh", defer:1

# a zsh plugin to help remembering those aliases you once defined
zplug "djui/alias-tips"

zplug "zsh-users/zsh-syntax-highlighting", defer:2 # run after compinit
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"

if zplug check "zsh-users/zsh-autosuggestions"; then
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down)
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}")
  ZSH_AUTOSUGGEST_USE_ASYNC=true
fi

if zplug check "zsh-users/zsh-history-substring-search"; then
  zmodload zsh/terminfo
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
  bindkey "$terminfo[cuu1]" history-substring-search-up
  bindkey "$terminfo[cud1]" history-substring-search-down
fi

zplug check --verbose || zplug install
zplug load

### SETTINGS & TOOLING CONFIGURATION ###

# zsh completions
fpath=($(brew --prefix)/share/zsh-completions $fpath)

# link up with iterm2
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# vagrant & vmware fusion
export VAGRANT_DEFAULT_PROVIDER=vmware_fusion

# use JDK8 as default
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
# eval "$(jenv init -)" # disable jenv for now

# GPGTools launches gpg-agent, we'll have to let SSH know we want to use gpg-agent as ssh-agent
#
# If succesful, you can read your SSH pubkey from the yubikey using `ssh-add -L`
if [ -f "${HOME}/.gnupg/gpg-agent.env" ]; then
  /usr/local/MacGPG2/bin/gpg-connect-agent /bye # be gone, ssh agent
  gpg --card-status > /dev/null # wake up yubikey
  . "${HOME}/.gnupg/gpg-agent.env"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
fi

# Timings integration
DISABLE_AUTO_TITLE="true"
PROMPT_TITLE='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
export PROMPT_COMMAND="${PROMPT_COMMAND} ${PROMPT_TITLE};"

# fzf integration, install if it does not exist
[ -z ~/.fzf.zsh ] && $(brew --prefix)/opt/fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Android tooling - managed by Android Studio
if [ -f "${HOME}/Library/Android/sdk/tools/android" ]; then
  export ANDROID_HOME=${HOME}/Library/Android/sdk
  export PATH=${ANDROID_HOME}/tools:$PATH
  export PATH=${ANDROID_HOME}/platform-tools:$PATH
fi

# Node, n and avn
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn
export N_PREFIX="$HOME/.n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# start node 8.7.0 by default
n 8.7.0

# install tooling if needed
[ -z ~/.n/bin/avn ] && npm install -g npm avn avn-n

# What the
eval "$(thefuck --alias fu)"

### ALIASES ###
# checkstyle
alias checkstyle-report="rg --before-context=5 severity=\\\"error **/target/checkstyle-result.xml"

# node stuff
alias nuke_modules="rm -rf node_modules; npm install; npm prune"

# Update all the things
alias update-casks="brew cask outdated --greedy --verbose | grep -v \"(latest)\" | cut -f1 -d\" \" | xargs brew cask reinstall"
alias update="softwareupdate --install --all --verbose; mas upgrade; brew update; brew upgrade; update-casks; brew cleanup -s; brew cask cleanup; brew prune"

# Pimp
alias ls="exa"
alias cat="ccat"
alias top="htop"
