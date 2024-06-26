$comfyUiDir = "$env:USERPROFILE/AppData/Local/Programs/ComfyUI"
$modelDir = "$env:USERPROFILE/Models"

conda install pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch-nightly -c nvidia
pip3 install comfy-cli
pip3 install --upgrade certifi

# comfy install is broken... https://github.com/Comfy-Org/comfy-cli/issues/98
if (-Not (Test-Path $comfyUiDir)) {
    Write-Host "💡 Cloning comfyui..."
    git clone https://github.com/comfyanonymous/ComfyUI.git $comfyUiDir
    Push-Location "$comfyUiDir/custom_nodes"
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git
    Pop-Location

    Push-Location $comfyUiDir
    Write-Host "💡 Installing comfyui dependencies"
    pip3 install -r requirements.txt
    Pop-Location

    comfy set-default $comfyUiDir

    Write-Host "💡 Setting up model dirs"
    New-Item -ItemType Directory -Path "$modelDir/StableDiffusion" -Force
    New-Item -ItemType Directory -Path "$modelDir/Clip" -Force
    New-Item -ItemType Directory -Path "$modelDir/ClipVision" -Force
    New-Item -ItemType Directory -Path "$modelDir/Configs" -Force
    New-Item -ItemType Directory -Path "$modelDir/ControlNet" -Force
    New-Item -ItemType Directory -Path "$modelDir/Embeddings" -Force
    New-Item -ItemType Directory -Path "$modelDir/Loras" -Force
    New-Item -ItemType Directory -Path "$modelDir/Upscale" -Force
    New-Item -ItemType Directory -Path "$modelDir/VAE" -Force

    Push-Location $comfyUiDir
    @"
comfyui:
  base_path: $modelDir
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
