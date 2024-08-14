#!/bin/bash
ARCH=$(uname -m)
if [ "$ARCH" != "arm64" ]; then
  echo "This script is intended for ARM Macs only, skipping..."
  exit 0
fi

COMFYUI_DIR=$HOME/Applications/ComfyUI
pushd "$COMFYUI_DIR" || exit
source .venv/bin/activate
uv pip install --upgrade comfy-cli
comfy update
popd
