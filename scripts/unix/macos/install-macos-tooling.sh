#!/bin/bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"

echo "💡 Installing minimal tooling"
brew bundle --no-lock --file=/dev/stdin <<EOF
brew "zsh"
brew "eza"
brew "bat"
brew "fzf"
brew "btop"
brew "jq"
brew "ripgrep"
brew "xh"
brew "navi"
brew "starship"
brew "zoxide"
brew "sheldon"
brew "watch"
brew "git"
brew "procs"
brew "dust"
brew "duf"
brew "prettyping"
brew "topgrade"
brew "neovim"
brew "coreutils"
brew "terminal-notifier"
brew "m-cli"
brew "mas"
EOF

if [ "$INSTALLATION_TYPE" = "workstation" ]; then
    echo "💡 Setting default shell to ZSH..."
    sudo chsh -s $(brew --prefix)/bin/zsh $(whoami)

    echo "💡 Installing workstation tooling"
    brew bundle --no-lock --file=/dev/stdin <<EOF
brew "pixi"
brew "pipx"
brew "uv"
brew "direnv"
brew "exiftool"
brew "lilypond"
brew "ly"
brew "pandoc"
brew "graphviz"
brew "devcontainer"
brew "wrk"
brew "hyperfine"
brew "dive"
brew "ctop"
brew "lnav"
brew "ollama"
brew "k9s"
brew "kubernetes-cli"
brew "helm"
brew "libpq"
brew "cypher-shell"
brew "awscli"
brew "aws-iam-authenticator"
cask "powershell"
cask "lm-studio"
cask "1password/tap/1password-cli"
cask "tailscale"
cask "keystore-explorer"
cask "zed"
cask "sdformatter"
tap "localsend/localsend"
cask "localsend"
cask "xpipe-io/tap/xpipe"
cask "core-tunnel"
cask "bluetility"
cask "wireshark"
cask "warp"
cask "sf-symbols"
cask "raycast"
cask "utm"
cask "crystalfetch"
EOF

    brew services restart ollama

    pushd "$BASEDIR" || exit
    echo "💡 Setting up Powershell..."
    pwsh ../../powershell/install.ps1

    echo "💡 Setting up ASDF..."
    ./setup-asdf.sh
    popd || exit
fi
