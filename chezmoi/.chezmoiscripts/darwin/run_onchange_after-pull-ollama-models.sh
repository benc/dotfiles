#!/bin/bash
if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

if type ollama &>/dev/null; then
    echo "🔧 Pulling ollama models..."

    # ollama pull "mistral-nemo:latest"
    # ollama pull "mistral:latest"
    # ollama pull "nomic-embed-text:latest"
fi
