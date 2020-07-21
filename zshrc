# zmodload zsh/zprof enable profiler

# bootstrap homebrew
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export EDITOR=code
# export EDITOR="/usr/local/bin/mate -w"

# Perl complains about this
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

### SHORTHANDS ###
setopt AUTOCD # ..
# setopt CORRECT # show corrections for commands

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
zplug "plugins/pipenv", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/mvn", from:oh-my-zsh
zplug "lib/spectrum", from:oh-my-zsh # colors
zplug "plugins/virtualenvwrapper", from:oh-my-zsh

# pure theme (async)
# zplug "mafredri/zsh-async"
# zplug "sindresorhus/pure", use:pure.zsh, as:theme

# spaceship theme
zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme

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

# navi - use it through homebrew until this works
#zplug denisidoro/navi
#source "$($ZPLUG_REPOS/denisidoro/navi/navi widget zsh)"
#export PATH=$ZPLUG_REPOS/denisidoro/navi/:$PATH

zplug check --verbose || zplug install
zplug load

### SETTINGS & TOOLING CONFIGURATION ###
# zsh completions
fpath=($(brew --prefix)/share/zsh-completions $fpath)

# link up with iterm2
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# vagrant & vmware fusion
export VAGRANT_DEFAULT_PROVIDER=vmware_desktop

# don't try to connect to spring config server
export SPRING_CLOUD_CONFIG_ENABLED=false

# Timings integration
DISABLE_AUTO_TITLE="true"
PROMPT_TITLE='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
export PROMPT_COMMAND="${PROMPT_COMMAND} ${PROMPT_TITLE};"

# fzf integration, install if it does not exist
[ -z ~/.fzf.zsh ] && $(brew --prefix)/opt/fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Android tooling - managed by IntelliJ
if [ -f "${HOME}/Library/Android/sdk/tools/android" ]; then
  export ANDROID_HOME=${HOME}/Library/Android/sdk
  export PATH=${ANDROID_HOME}/tools:$PATH
  export PATH=${ANDROID_HOME}/tools/bin:$PATH
  export PATH=${ANDROID_HOME}/platform-tools:$PATH
fi

# JProfiler
export PATH=/Applications/JProfiler.app/Contents/Resources/app/bin:$PATH

# Node, n and avn
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn - TODO fix issue in webstorm when containing .node-version
export N_PREFIX="$HOME/.n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
export PATH=./node_modules/.bin:$PATH

# Asciidoc
function asciidoc2md() {
  asciidoctor -b docbook -a leveloffset=+1 -o - "$1" | pandoc --atx-headers --wrap=preserve -t markdown_strict -f docbook - > "$1".md
}

# Postgres client tooling - brew install libpq
export PATH=/usr/local/opt/libpq/bin:$PATH

# start node
# n v12.18.2

# install tooling if needed
# [ -z ~/.n/bin/avn ] && npm install -g npm avn avn-n

# What the
eval "$(thefuck --alias fu)"

# Kubernetes
# source <(stern --completion=zsh)

# Docker
if [ -d "/Applications/Docker.app/Contents/Resources/etc/" ]; then
  for f in "/Applications/Docker.app/Contents/Resources/etc/"*.zsh-completion; do
    source "$f"
  done
fi

# pipenv
eval "$(pipenv --completion)"

# add local commands to PATH
export PATH=./bin:$PATH

### ALIASES ###
# checkstyle
alias checkstyle-report="rg --before-context=5 severity=\\\"error **/target/checkstyle-result.xml"

# node stuff
alias nuke_modules="rm -rf node_modules; npm install; npm prune"

# Update all the things
alias update-casks="brew cask outdated --greedy --verbose | grep -v \"(latest)\" | cut -f1 -d\" \" | xargs brew cask reinstall"
alias update="softwareupdate --install --all --verbose; mas upgrade; brew update; brew upgrade; update-casks; brew cleanup -s; sdk update; sdk upgrade"

# Pimp
alias ls="exa"
alias cat="ccat --bg=\"dark\""
alias top="htop"

# NSSurge
# export https_proxy=http://127.0.0.1:6152
# export http_proxy=http://127.0.0.1:6152
# export all_proxy=socks5://127.0.0.1:6153

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"

eval $(thefuck --alias)

# zprof > ~/.zprof # printout profiling