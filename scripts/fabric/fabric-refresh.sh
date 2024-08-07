#!/bin/bash
set -e

ARCH=$(uname -m)
if [ "$ARCH" != "arm64" ]; then
  echo "This script is intended for ARM Macs only, skipping..."
  exit 0
fi

FABRIC_DIR=$HOME/Applications/Fabric
DEFAULT_MODEL=mistral-nemo:latest

ollama pull "$DEFAULT_MODEL"

if [ ! -d "$FABRIC_DIR" ]; then # install
  echo "💡 Cloning fabric..."
  git clone https://github.com/danielmiessler/fabric "$FABRIC_DIR"

  echo "🚀 Installing fabric..."  
  pushd "$FABRIC_DIR" || exit
  pipx install .
  fabric --setup
  popd
else
  pushd "$FABRIC_DIR" || exit
  pipx install . --force
  fabric --update
  popd
fi

fabric --changeDefaultModel $DEFAULT_MODEL
