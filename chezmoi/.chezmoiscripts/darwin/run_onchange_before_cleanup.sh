#!/bin/bash
echo "🗑️ Cleanup packages..."

if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

if ! command -v brew &> /dev/null; then
  echo "brew not found, nothing to clean..."
  exit 0
fi

# replaced by musescore
brew remove lilypond || true
brew remove ly || true

# install separately
brew remove microsoft-office || true

# superceded by windows app
brew remove microsoft-remote-desktop || true
sudo mas uninstall 1295203466 || true # windows app - install it through brew

# not used
brew remove postico || true
brew remove xpipe-io/tap/xpipe || true
brew untap xpipe-io/tap || true
brew remove arq || true
