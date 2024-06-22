#!/bin/bash
COMFYUI_DIR=$HOME/Applications/comfyui

BASEDIR=$COMFYUI_DIR
ARCHITECTURE=$(uname -m)

mkdir -p "$BASEDIR"
# pushd BASEDIR

install_apple_miniconda() {
    if is_installed conda; then
        echo "conda already installed"
        install_python
        conda activate "${CONDA_ENV_NAME}" 
        install_torch
        return $?
    fi

    if [[ "$ARCHITECTURE" == "arm64" ]]; then
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -O miniconda.sh
    else
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh
    fi

    bash miniconda.sh -b
    if [ $? -eq 0 ]; then
        echo "Installed conda successfully."
    else
        echo "Failed to install conda."
        return 1
    fi
}
