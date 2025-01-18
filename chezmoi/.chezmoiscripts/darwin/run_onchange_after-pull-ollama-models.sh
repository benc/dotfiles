#!/bin/bash
if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

if type ollama &>/dev/null; then
    echo "🔧 Pulling ollama models..."

    ollama pull "llama3.3:latest"
    ollama pull "qwq:latest"
    ollama pull "qwen2.5-coder:latest"
    ollama pull "nomic-embed-text:latest"
fi
