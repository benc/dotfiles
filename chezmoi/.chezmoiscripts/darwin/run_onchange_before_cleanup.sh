#!/bin/bash
echo "🗑️ Cleanup packages..."

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

if ! command -v brew &> /dev/null; then
  echo "brew not found, nothing to clean..."
  exit 1
fi

# replaced by musescore
brew remove lilypond || true
brew remove ly || true
