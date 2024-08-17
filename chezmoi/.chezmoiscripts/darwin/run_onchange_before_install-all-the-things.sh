#!/bin/bash
if [ ! -f "/usr/local/bin/brew" ] && [ ! -f "/opt/homebrew/bin/brew" ]; then
    echo "🍺 Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! type nix &>/dev/null; then
    echo "❄️ Installing nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/installation-type.sh
else
    echo "☢️  No installation type set, did you run this script directly? Assuming 'workstation' installation."
    INSTALLATION_TYPE=workstation
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
    brew bundle --force --no-lock --file=/dev/stdin <<EOF
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
cask "apparency"
cask "qlvideo"
cask "provisionql"
cask "quicklookapk"
cask "1password/tap/1password-cli"
cask "softraid"
cask "logitune"
cask "jordanbaird-ice"
cask "warp"
cask "microsoft-remote-desktop"
cask "sdformatter"
cask "powershell"
tap "localsend/localsend"
cask "localsend"
cask "xpipe-io/tap/xpipe"
cask "raycast"
cask "sf-symbols"
cask "crystalfetch"
cask "carbon-copy-cloner"
cask "arq"
cask "calibre"
cask "betterdisplay"
cask "rectangle-pro"
cask "power-manager"
cask "syncthing"
cask "keyboard-maestro"
cask "appcleaner"
cask "ivpn"
cask "little-snitch"
cask "tailscale"
cask "transmit"
cask "imazing"
cask "iina"
cask "launchcontrol"
cask "whatsapp"
cask "telegram"
cask "messenger"
cask "discord"
cask "daisydisk"
cask "jetbrains-toolbox"
cask "jprofiler"
cask "jd-gui"
cask "beyond-compare"
cask "kaleidoscope"
cask "tower"
cask "postico"
cask "orbstack"
cask "utm"
cask "core-tunnel"
cask "bluetility"
cask "wireshark"
cask "keystore-explorer"
cask "zed"
cask "bbedit"
cask "visual-studio-code@insiders"
cask "choosy"
cask "google-chrome"
cask "firefox"
cask "brave-browser"
cask "microsoft-edge"
cask "lm-studio"
cask "diffusionbee"
cask "replacicon"
cask "swiftbar"
cask "fantastical"
cask "omnifocus"
cask "omnigraffle"
cask "omnioutliner"
cask "microsoft-office"
cask "microsoft-teams"
cask "zoom"
cask "tradingview"
cask "devonthink"
cask "setapp"
cask "spamsieve"
cask "soundsource"
cask "airfoil"
cask "plex-media-server"
cask "fujitsu-scansnap-home"
cask "tageditor"
cask "ableton-live-suite@11"
cask "melodics"
cask "insta360-studio"
mas "JSONPeep", id: 1458969831
mas "OK JSON", id: 1576121509
mas "Pure Paste", id: 1611378436
mas "Refined GitHub", id: 1519867270
mas "Peek", id: 1554235898
mas "Aiko", id: 1672085276
mas "1Focus", id: 969210610
mas "Mindnode", id: 1289197285
mas "BaseCamp", id: 411052274
mas "NepTunes", id: 1006739057
mas "Actions", id: 1586435171
mas "Ivory", id: 6444602274
mas "Amphetamine", id: 937984704
mas "1Password for Safari", id: 1569813296
mas "MusicBox", id: 1614730313
mas "Logic Pro", id: 634148309
mas "Xcode", id: 497799835
mas "GarageBand", id: 682658836
mas "Reeder", id: 1529448980
mas "Shortery", id: 1594183810
mas "Formatter", id: 1190228172
mas "Speediness", id: 1596706466
mas "One Thing", id: 1604176982
mas "Infuse", id: 1136220934
mas "Prompt", id: 1594420480
mas "Remote Desktop", id: 409907375
mas "Side Mirror", id: 944860108
mas "com.kagimacOS.Kagi-Search", id: 1622835804
EOF

    brew services restart ollama

    echo "🔧 Checking current default shell..."
    current_shell=$(dscl . -read /Users/$(whoami) UserShell | awk '{print $2}')

    if [ "$current_shell" != "$(brew --prefix)/bin/zsh" ]; then
        echo "🔧 Setting default shell to ZSH..."
        sudo chsh -s $(brew --prefix)/bin/zsh $(whoami)
    else
        echo "🔧 Default shell is already ZSH."
    fi

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