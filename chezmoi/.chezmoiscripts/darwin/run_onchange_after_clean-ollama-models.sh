#!/bin/bash
if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

if type ollama &>/dev/null; then
    echo "🔧 Cleanup ollama models..."
fi
