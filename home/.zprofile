#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source profile.d.
for zsh_source in $HOME/.profile.d/*.zsh; do
  source $zsh_source
done