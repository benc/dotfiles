#!/bin/bash
#
# This script assumes that a recent conda is installed.
#
# Can be done with asdf or by executing the following commands:
#
#   curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
#   sh Miniconda3-latest-MacOSX-arm64.sh
if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

ARCH=$(uname -m)
if [ "$ARCH" != "arm64" ]; then
  echo "This script is intended for ARM Macs only, skipping..."
  exit 0
fi

COMFYUI_DIR=$HOME/Applications/ComfyUI
MODEL_DIR=$HOME/Models

if [ -d "$COMFYUI_DIR" ]; then # already installed
  echo "ComfyUI is already installed."
  exit 0
fi

if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

# comfy install is broken... https://github.com/Comfy-Org/comfy-cli/issues/98
echo "💡 Cloning comfyui..."
git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFYUI_DIR"
pushd "$COMFYUI_DIR/custom_nodes" || exit
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
popd || exit

pushd "$COMFYUI_DIR" || exit
# uv venv --python "$(conda info --base)/bin/python3" && source .venv/bin/activate
uv venv && source .venv/bin/activate

echo "layout python3" >>.envrc
echo "source .venv/bin/activate" >>.envrc
direnv allow .

echo "💡 Installing comfyui dependencies"
uv pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu
uv pip install comfy-cli
uv pip install --upgrade certifi pip
# uv pip -y install onnxruntime-silicon
uv pip install -r requirements.txt
popd || exit

comfy set-default "$COMFYUI_DIR"

echo "💡 Setting up model dirs"
mkdir -p "$MODEL_DIR/StableDiffusion"
mkdir -p "$MODEL_DIR/Clip"
mkdir -p "$MODEL_DIR/ClipVision"
mkdir -p "$MODEL_DIR/Configs"
mkdir -p "$MODEL_DIR/ControlNet"
mkdir -p "$MODEL_DIR/Embeddings"
mkdir -p "$MODEL_DIR/Loras"
mkdir -p "$MODEL_DIR/Upscale"
mkdir -p "$MODEL_DIR/VAE"

pushd "$COMFYUI_DIR" || exit
cat >extra_model_paths.yaml <<EOL
comfyui:
  base_path: ${HOME}/Models
  checkpoints: StableDiffusion
  clip: Clip
  clip_visio: ClipVision
  configs: Configs
  controlnet: ControlNet
  embeddings: Embeddings
  loras: Loras
  upscale_models: Upscale
  vae: VAE
EOL
popd || exit
