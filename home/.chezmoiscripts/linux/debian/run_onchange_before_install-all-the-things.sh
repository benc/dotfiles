#!/bin/bash

if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/installation-type.sh
else
    echo "☢️  No installation type set, did you run this script directly? Assuming 'workstation' installation."
    INSTALLATION_TYPE=workstation
fi

echo "💡 Installing minimal tooling"
curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get
sudo apt-get -y install \
    zsh \
    bat \
    fzf \
    btop \
    jq \
    ripgrep \
    zoxide \
    duf \
    prettyping \
    neovim

deb-get install du-dust

if [ "$INSTALLATION_TYPE" = "workstation" ]; then
    echo "💡 Setting default shell to ZSH..."
    sudo chsh -s /usr/bin/zsh $(whoami)

    echo "💡 Installing workstation tooling"
    sudo apt-get -y install \
        pipx \
        direnv \
        exiftool \
        lilypond \
        pandoc \
        graphviz \
        wrk \
        hyperfine \
        lnav \
        awscli
    
    deb-get install \
        1password \
        dive \
        localsend

    # Docker
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Tailscale
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    sudo apt-get update && sudo apt-get install -y tailscale

    # PowerShell
    source /etc/os-release
    wget -q https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb
    sudo apt-get update && sudo apt-get install -y powershell

    # Kubectl
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/keyrings/kubernetes-apt-keyring.gpg > /dev/null
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list 
    sudo apt-get update
    sudo apt-get install -y kubectl

    # Helm
    curl  -fsSL https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm

    # ctop
    curl -fsSL https://azlux.fr/repo.gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/azlux-archive-keyring.gpg > /dev/null
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian \
    $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azlux.list >/dev/null
    sudo apt-get update
    sudo apt-get install docker-ctop

    # code-insiders
    curl -fsSL https://azlux.fr/repo.gpg.key | gpg --dearmor | sudo tee packages.microsoft.gpg > /dev/null
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
    sudo apt-get update
    sudo apt-get install code-insiders

    pushd "$BASEDIR" || exit
    curl -sS https://starship.rs/install.sh | sh -s -- --force
    curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | XH_BINDIR=/usr/local/bin sh

    echo "💡 Setting up Powershell..."
    pwsh ../powershell/install.ps1

    pushd "$BASEDIR/.." || exit
    echo "💡 Setting up ASDF..."
    ./setup-asdf.sh
    popd || exit
    popd || exit
fi
