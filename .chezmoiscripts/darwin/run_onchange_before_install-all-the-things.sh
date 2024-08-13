#!/bin/bash
if [ ! -f "/usr/local/bin/brew" ] && [ ! -f "/opt/homebrew/bin/brew" ]; then
    echo "🍺 Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "🔧 Installing minimal tooling"
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
    echo "🔧 Installing workstation tooling"
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
brew "docker-credential-helper-ecr"
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

    echo "🔧 Setting default shell to ZSH..."
    sudo chsh -s $(brew --prefix)/bin/zsh $(whoami)

    # TODO fix pwsh setup
    # pushd "$BASEDIR" || exit
    # echo "💡 Setting up Powershell..."
    # pwsh ../../powershell/install.ps1
    # popd || exit

    echo "🔧 Installing ASDF..."
    if [ ! -d $HOME/.asdf ]; then
        echo "💡 Installing asdf..."
        git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf
        . "$HOME/.asdf/asdf.sh"
        asdf update
    fi

    . "$HOME/.asdf/asdf.sh"

    asdf plugin add nodejs
    asdf plugin add ruby
    asdf plugin add java
    asdf plugin add maven
    asdf plugin add gradle
    asdf plugin add python
    asdf plugin add golang
    asdf plugin add rust
fi
