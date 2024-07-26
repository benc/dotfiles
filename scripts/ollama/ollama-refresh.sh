#!/bin/bash
set -e

desired_models=("mistral-large:latest" "mistral-nemo:latest" "mistral:latest" "nomic-embed-text:latest")

pull_model() {
  local model=$1
  echo "Installing $model..."
  ollama pull "$model"
}

# Install models that are in the desired list
for model in "${desired_models[@]}"; do
  pull_model "$model"
done
