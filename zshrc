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

  # history, syntax highlighting
  # NOTE if zsh-syntax-highlighting is bundled after zsh-history-substring-search, they break, so get the order right.
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search

  # Set keystrokes for substring searching
  zmodload zsh/terminfo
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down

  # completions
  zgen load zsh-users/zsh-completions src

  # pure theme (async)
  zgen load mafredri/zsh-async
  zgen load sindresorhus/pure

  # fancy schmancy
  zgen load chrissicool/zsh-256color

  # fish like autosuggestions
  zgen load tarruda/zsh-autosuggestions

  # k is a zsh script / plugin to make directory listings more readable,
  # adding a bit of color and some git status information on files and directories
  zgen load rimraf/k

  # a next-generation cd command with an interactive filter
  # zgen load b4b4r07/enhancd

  # automatically run zgen update and zgen selfupdate every 7 days
  zgen load unixorn/autoupdate-zgen

  # save all to init script
  zgen save
fi

export EDITOR=subl

# link up with iterm2
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# vscode
alias code="/Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron"

# Enable autosuggestions automatically.
zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init
