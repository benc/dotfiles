#!/bin/bash
if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/installation-type.sh
else
    echo "☢️  No installation type set, did you run this script directly? Assuming 'workstation' installation."
    INSTALLATION_TYPE=workstation
fi

export NIXPKGS_ALLOW_UNFREE=1

if ! type nix &>/dev/null; then
    echo "❄️ Installing nix..."
    sudo apt-get -y install xz-utils
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

echo "🔧 Installing minimal tooling"
nix registry add nixpkgs https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz
nix profile install --impure \
    nixpkgs#zsh \
    nixpkgs#eza \
    nixpkgs#bat \
    nixpkgs#fzf \
    nixpkgs#btop \
    nixpkgs#jq \
    nixpkgs#ripgrep \
    nixpkgs#xh \
    nixpkgs#navi \
    nixpkgs#starship \
    nixpkgs#zoxide \
    nixpkgs#sheldon \
    nixpkgs#git \
    nixpkgs#procs \
    nixpkgs#dust \
    nixpkgs#duf \
    nixpkgs#prettyping \
    nixpkgs#topgrade \
    nixpkgs#neovim \
    nixpkgs#_1password

if [ "$INSTALLATION_TYPE" = "workstation" ]; then
    echo "💡 Setting default shell to ZSH..."
    sudo chsh -s /usr/bin/zsh $(whoami)

    echo "💡 Installing workstation tooling"
    nix profile install --impure \
        nixpkgs#pixi \
        nixpkgs#pipx \
        nixpkgs#uv \
        nixpkgs#direnv \
        nixpkgs#exiftool \
        nixpkgs#lilypond \
        nixpkgs#ly \
        nixpkgs#pandoc \
        nixpkgs#graphviz \
        nixpkgs#devcontainer \
        nixpkgs#wrk \
        nixpkgs#hyperfine \
        nixpkgs#dive \
        nixpkgs#ctop \
        nixpkgs#lnav \
        nixpkgs#k9s \
        nixpkgs#kubectl \
        nixpkgs#helm \
        nixpkgs#postgresql \
        nixpkgs#neo4j \
        nixpkgs#awscli \
        nixpkgs#aws-iam-authenticator \
        nixpkgs#docker-credential-helpers
fi
