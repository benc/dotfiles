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
