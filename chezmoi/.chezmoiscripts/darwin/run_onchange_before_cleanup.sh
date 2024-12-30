#!/bin/bash
if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

echo "🗑️ Cleanup packages..."

if ! command -v brew &> /dev/null; then
  echo "brew not found, nothing to clean..."
  exit 0
fi
