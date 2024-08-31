# Source tooling
if [ -f "/usr/local/bin/brew" ]; then
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi

if [ -f "/opt/homebrew/bin/brew" ]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

if [ -f "/opt/linuxbrew/bin/brew" ]; then
  export PATH="/opt/linuxbrew/bin:/opt/linuxbrew/sbin:$PATH"
fi

if command -v brew &> /dev/null; then
  eval "$(brew shellenv)"
fi

if [ -f "$HOME/.asdf/asdf.sh" ]; then
  source "$HOME/.asdf/asdf.sh"
fi
