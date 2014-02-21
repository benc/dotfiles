#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source profile.d.
profile.d/*.zsh; do
  source $zsh_source
done