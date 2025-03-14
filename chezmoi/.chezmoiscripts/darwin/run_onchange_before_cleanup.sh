#!/bin/bash
if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

echo "🗑️ Cleanup packages..."

if ! command -v brew &> /dev/null; then
  echo "brew not found, nothing to clean..."
  exit 0
fi

# replaced by ghostty
brew remove warp || true
brew remove alacritty || true

# deprecated
brew remove quicklookapk || true 

# use bolt ai
brew remove lm-studio || true

# not used
brew remove atuin || true

# use librewolf
brew remove brave-browser || true

# basecamp to homebrew
sudo mas uninstall 411052274 || true # garmin mapping tool

# use mise
brew remove asdf
rm -rf ~/.asdf
