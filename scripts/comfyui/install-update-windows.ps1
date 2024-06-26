$COMFYUI_DIR = "$env:USERPROFILE/AppData/Local/Programs/ComfyUI"
$MODEL_DIR = "$env:USERPROFILE/Models"

pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu124
pip3 install comfy-cli
pip3 install --upgrade certifi

# comfy install is broken... https://github.com/Comfy-Org/comfy-cli/issues/98
if (-Not (Test-Path $COMFYUI_DIR)) {
    Write-Host "💡 Cloning comfyui..."
    git clone https://github.com/comfyanonymous/ComfyUI.git $COMFYUI_DIR
    Push-Location "$COMFYUI_DIR/custom_nodes"
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git
    Pop-Location

    Push-Location $COMFYUI_DIR
    Write-Host "💡 Installing comfyui dependencies"
    pip3 install -r requirements.txt
    Pop-Location

    comfy set-default $COMFYUI_DIR

    Write-Host "💡 Setting up model dirs"
    New-Item -ItemType Directory -Path "$MODEL_DIR/StableDiffusion" -Force
    New-Item -ItemType Directory -Path "$MODEL_DIR/Clip" -Force
    New-Item -ItemType Directory -Path "$MODEL_DIR/ClipVision" -Force
    New-Item -ItemType Directory -Path "$MODEL_DIR/Configs" -Force
    New-Item -ItemType Directory -Path "$MODEL_DIR/ControlNet" -Force
    New-Item -ItemType Directory -Path "$MODEL_DIR/Embeddings" -Force
    New-Item -ItemType Directory -Path "$MODEL_DIR/Loras" -Force
    New-Item -ItemType Directory -Path "$MODEL_DIR/Upscale" -Force
    New-Item -ItemType Directory -Path "$MODEL_DIR/VAE" -Force

    Push-Location $COMFYUI_DIR
    @"
comfyui:
  base_path: $env:USERPROFILE\Models
  checkpoints: StableDiffusion
  clip: Clip
  clip_visio: ClipVision
  configs: Configs
  controlnet: ControlNet
  embeddings: Embeddings
  loras: Loras
  upscale_models: Upscale
  vae: VAE
"@ | Out-File -FilePath "extra_model_paths.yaml" -Encoding utf8
    Pop-Location
}

comfy update
