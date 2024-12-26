#!/bin/bash
echo "Asking for sudo rights in order to install tooling..."
sudo -v

if [ ! -f "/usr/local/bin/brew" ] && [ ! -f "/opt/homebrew/bin/brew" ]; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/installation-type.sh
else
    echo "☢️  No installation type set, did you run this script directly? Set INSTALLATION_TYPE using an env var if needed."
fi

if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

echo "🔧 Installing prerequisites.."
brew bundle --no-lock --file=/dev/stdin <<EOF
# shell and basic cli tooling
brew "zsh" # shell
brew "eza" # ls replacement
brew "bat" # cat replacement
brew "fzf" # fuzzy finder
brew "fd" # find replacement
brew "btop" # top replacement
brew "jq" # json processor
brew "yq" # yaml, json and xml processor
brew "xq" # xml & html processor
brew "fx" # json viewer
brew "ripgrep" # grep replacement
brew "delta" # diff viewer
brew "xh" # curl replacement
brew "navi" # cheatsheet
brew "starship" # prompt
brew "zoxide" # cd replacement
brew "sheldon" # plugin manager
brew "watch" # watch command
brew "git" # version control
brew "procs" # ps replacement
brew "dust" # du replacement
brew "duf" # df replacement
brew "prettyping" # ping replacement
brew "coreutils" # gnu coreutils
brew "m-cli" # swiss army knife for macos
brew "mas" # mac app store cli
brew "tag" # manipulate and query tags on macos files
EOF

if [ "$APPLY_SECRETS" = "true" ] || [ "$INSTALLATION_TYPE" = "regular" ] || [ "$INSTALLATION_TYPE" = "workstation" ]; then
    echo "🔧 Installing 1Password"
    brew bundle --no-lock --file=/dev/stdin <<EOF
# 1password
cask "1password" # 1password
cask "1password/tap/1password-cli" # 1password cli
mas "1Password for Safari", id: 1569813296 # 1password safari extension
EOF
    # TODO check if op ... is configured correcly, if not, exit script and ask user to configure, then run bootstrap again
    op_account_size="$(op account list --format=json | jq -r '. | length')"

    if [[ "${op_account_size}" == "0" ]]; then
    echo "⚠️ 1password is not configured correctly. Launch 1Password, sign in and couple it to the CLI. Then run this bootstrap script again."
        echo
        echo "   op account add --address $SUBDOMAIN.1password.com --email $LOGIN"
        echo
        exit 1
    fi
fi

echo "🔧 Installing the essentials..."
brew bundle --no-lock --file=/dev/stdin <<EOF
brew "lazygit" # git ui
brew "topgrade" # update everything
brew "neovim" # text editor
brew "terminal-notifier" # notifications - TODO switch to ntfy
brew "ntfy"
brew "mpv" # video player

# quicklook plugins
cask "apparency" # quicklook for apps https://www.mothersruin.com/software/Apparency/
cask "qlvideo" # quicklook for video files

# drivers
cask "softraid" # owc softraid https://www.softraid.com/
cask "logitune" # yet another logitech tool
cask "logitech-g-hub" # yet another logitech tool
cask "soundsource" # system audio manager
cask "steermouse" # a better mouse driver
cask "lihaoyun6/tap/airbattery" # see battery status - smaller, free version of airbuddy
cask "aldente" # battery management
cask "via" # qmk manager
cask "karabiner-elements" # keyboard remapper

# system tooling
cask "jordanbaird-ice" # macos menubar manager
cask "raycast" # spotlight replacement
cask "contexts" # switch between apps
cask "latest" # latest version of apps
cask "alacritty" # terminal
cask "connectmenow" # mount network shares
cask "carbon-copy-cloner" # backup tool
cask "sdformatter" # sd card formatter
cask "betterdisplay" # display manager
cask "rectangle-pro" # window manager
cask "appcleaner" # app uninstaller
cask "daisydisk" # disk space analyzer
cask "prefs-editor" # macos prefs editor
cask "visual-studio-code" # code editor
cask "setapp" # app subscription
mas "Amphetamine", id: 937984704 # keep mac awake

# productivity
cask "google-chrome" # browser
cask "adobe-acrobat-reader" # pdf reader

# network tooling
cask "tailscale" # vpn
cask "spamsieve" # spam filter
mas "Speediness", id: 1596706466 # check internet speed https://sindresorhus.com/speediness
EOF

# fix zsh compinit insecure directories warning
sudo chmod 755 "$(brew --prefix)/share"

echo "🔧 Checking current default shell..."
current_shell=$(dscl . -read /Users/$(whoami) UserShell | awk '{print $2}')

if [ "$current_shell" != "$(brew --prefix)/bin/zsh" ]; then
    echo "🔧 Setting default shell to ZSH..."
    sudo chsh -s $(brew --prefix)/bin/zsh $(whoami)
else
    echo "🔧 Default shell is already ZSH."
fi

if [ "$INSTALLATION_TYPE" = "regular" ] || [ "$INSTALLATION_TYPE" = "workstation" ]; then
    echo "🔧 Installing regular tooling..."
    brew bundle --no-lock --file=/dev/stdin <<EOF
# messaging
cask "whatsapp"
cask "telegram"
cask "messenger"
cask "discord"
cask "signal"

# productivity
cask "microsoft-word" # ms office
cask "microsoft-excel" # ms office
cask "microsoft-powerpoint" # ms office
cask "fantastical" # macos calendar replacement
cask "microsoft-teams" # video conferencing
cask "zoom" # video conferencing
cask "omnifocus" # task manager
cask "omnigraffle" # diagram tool
cask "omnioutliner" # outliner tool
cask "devonthink" # document manager
mas "Peek", id: 1554235898 # quick look extension https://www.bigzlabs.com/peek.html
mas "Mindnode", id: 1289197285 # mind mapping
mas "Mindnode Next", id: 6446116532 # mind mapping
mas "Reeder", id: 1529448980 # rss reader
mas "Side Mirror", id: 944860108 # presentation tool https://sidemirrorapp.com
mas "StopTheMadness Pro", id: 6471380298 # sanitize safari https://underpassapp.com/StopTheMadness/

# automation
mas "Actions", id: 1586435171 # additional actions for the shortcut app https://sindresorhus.com/actions
mas "Shortery", id: 1594183810 # automate shortcuts https://www.numberfive.co/detail_shortery.html

# finance
cask "tradingview" # stock trading
mas "Keepa - Price Tracker", id: 1533805339 # amazon price tracker

# media
cask "calibre" # ebook manager
cask "iina" # video player
mas "Infuse", id: 1136220934 # video player
cask "insta360-studio" # 360 camera
cask "airfoil" # apple airplay audio streamer
cask "melodics" # music learning
cask "musescore" # music notation
mas "GarageBand", id: 682658836 # music creation
mas "Cascable", id: 974193500 # camera control https://cascable.se
EOF
fi

if [ "$INSTALLATION_TYPE" = "server" ] || [ "$INSTALLATION_TYPE" = "workstation" ]; then
    echo "🔧 Installing server tooling..."
    brew bundle --no-lock --file=/dev/stdin <<EOF
# data tooling
brew "libpq" # postgresql client tooling
brew "pgcli" # better psql
brew "cypher-shell" # neo4j client tooling
tap "xo/xo" # usql tap
brew "usql" # universal sql client

# log analysis
brew "lnav" # log viewer

# aws tooling
brew "awscli" # aws tooling
brew "aws-iam-authenticator" # aws k8s auth
brew "docker-credential-helper-ecr" # docker ecr auth
tap "aws/tap" # aws tap
brew "eks-node-viewer" # eks node viewer

# k8s tooling
tap "derailed/k9s" # k9s tap
brew "k9s" # k8s ui
brew "kubernetes-cli" # k8s cli
brew "helm" # k8s package manager
brew "stern" # k8s log viewer
brew "kubectx" # k8s context manager

# docker tooling
brew "dive" # docker container image explorer
brew "ctop" # container top
cask "orbstack" # docker desktop replacement

# virtualization
cask "utm" # virtualization

# media
cask "plex-media-server" # media server
brew "exiftool" # image metadata tool

# productivity
cask "fujitsu-scansnap-home" # scanner manager

# ai
brew "ollama" # serve genai models

# network tooling
cask "localsend/localsend/localsend" # local file sharing
cask "syncthing" # file sync
cask "core-tunnel" # ssh tunnel
cask "wireshark" # network analyzer
cask "transmit" # ftp client
cask "windows-app" # remote desktop
cask "little-snitch" # network monitor
cask "ngrok" # reverse proxy, secure introspectable tunnels to localhost

# utilities
cask "power-manager" # power management
cask "imazing" # ios device manager
cask "launchcontrol" # launchd manager
EOF

    brew services restart ollama

    echo "🔧 Installing ASDF..."
    if [ ! -d $HOME/.asdf ]; then
        echo "💡 Installing asdf..."
        git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf
        . "$HOME/.asdf/asdf.sh"
        asdf update
    fi
fi

if [ "$INSTALLATION_TYPE" = "workstation" ]; then
    # install nix only on workstation for now...
    if ! type nix &>/dev/null; then
        echo "❄️ Installing nix..."
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi

    echo "🔧 Installing workstation tooling..."
    brew bundle --force --no-lock --file=/dev/stdin <<EOF
# development tooling
brew "scc" # code counter with complexity calculations and cocomo estimates
brew "hyperfine" # cli benchmarking
brew "devcontainer" # dockerize dev env
brew "hadolint" # dockerfile linter
brew "gh" # github cli
brew "glab" # gitlab cli
cask "jetbrains-toolbox" # jetbrains ide manager
cask "zed" # code editor
cask "visual-studio-code@insiders" # code editor
cask "bbedit" # code editor
cask "beyond-compare" # file comparison
cask "kaleidoscope" # file comparison
cask "tower" # git client
cask "kindavim" # vim keybindings for macos
mas "JSONPeep", id: 1458969831 # json viewer
mas "OK JSON", id: 1576121509 # json viewer
mas "Xcode", id: 497799835 # apple development tool
mas "Formatter", id: 1190228172 # json for xcode https://roundwallsoftware.com/formatter/

# python development
brew "pixi" # package manager
brew "pipx" # python package manager
brew "uv" # python package manager
brew "direnv" # env manager 

# java development
cask "jprofiler" # java profiler
cask "jd-gui" # java decompiler
cask "keystore-explorer" # java keystore manager

# mobile development
cask "provisionql" # quicklook for ipa & provision
cask "quicklookapk" # quicklook for apk

# media
brew "pandoc" # document converter
brew "graphviz" # graph tool
cask "sf-symbols" # symbol tool

# home automation
mas "MQTT Explorer", id: 1455214828

# web development
brew "wrk" # http benchmarking
cask "choosy" # browser chooser
cask "firefox" # browser
cask "brave-browser" # browser
cask "microsoft-edge" # browser

# cli
cask "powershell" # shell
cask "warp" # terminal

# devops
cask "crystalfetch" # create windows 11 iso images

# bluetooth development
cask "bluetility" # bluetooth low energy browser

# ai
cask "lm-studio" # ai tool
cask "diffusionbee" # image generator
mas "Aiko", id: 1672085276 # on device transcription https://sindresorhus.com/aiko

# maps
mas "BaseCamp", id: 411052274 # garmin mapping tool
cask "google-earth-pro" # google mapping tool

# utilties
cask "keyboard-maestro" # keyboard automation
cask "caldigit-docking-utility" # caldigit dock manager
cask "keycastr" # keypress visualizer
cask "replacicon" # icon replacer
cask "swiftbar" # menubar app
mas "Pure Paste", id: 1611378436 # paste text as plain text by default https://sindresorhus.com/pure-paste
mas "Refined GitHub", id: 1519867270 # github ui improvements
mas "1Focus", id: 969210610 # focus app
mas "One Thing", id: 1604176982 # put a single task in menu bar https://sindresorhus.com/one-thing
mas "Prompt", id: 1594420480 # shell/ssh client
mas "com.kagimacOS.Kagi-Search", id: 1622835804 # search tool https://kagi-search.com

# media
cask "tageditor" # music tag editor
cask "ableton-live-suite@11" # music creation
mas "NepTunes", id: 1006739057 # itunes controller
mas "MusicBox", id: 1614730313 # save music for later
mas "Logic Pro", id: 634148309 # music creation
EOF

    # TODO fix pwsh setup
    # pushd "$BASEDIR" || exit
    # echo "💡 Setting up Powershell..."
    # pwsh ../../powershell/install.ps1
    # popd || exit
fi
