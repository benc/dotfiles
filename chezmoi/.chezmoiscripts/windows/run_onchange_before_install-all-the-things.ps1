Write-Output "🔧 Installing tooling - winget..."

# assuming 'workstation' for windows machines, so we'll be installing everything

 # tailscale scoop version does not install correctly
$apps = @(
    "SomePythonThings.WingetUIStore",
    "AgileBits.1Password",
    "BelgianGovernment.eIDViewer",
    "Microsoft.WindowsTerminal",
    "JetBrains.Toolbox",
    "SaaSGroup.Tower",
    "Intel.IntelDriverAndSupportAssistant",
    "Docker.DockerDesktop",
    "Proxyman.Proxyman",
    "Microsoft.VisualStudio.2022.Community",
    "tailscale.tailscale",
    "WhatsApp.WhatsApp",
    "Facebook.Messenger",
    "Logitech.LogiTune",
    "Anaconda.Miniconda3",
    "prefix-dev.pixi",
    "Ollama.Ollama",
    "LMStudio.LMStudio",
    "TradingView.TradingViewDesktop",
    "DigiDNA.iMazing",
    "Melodics.Melodics",
    "EPOS.EposConnect",
    "Garmin.BaseCamp",
    "Adobe.Acrobat.Reader.64-bit"
)

$osIsARM = $env:PROCESSOR_ARCHITECTURE -match '^arm.*'
$osIs64Bit = [System.Environment]::Is64BitOperatingSystem
$osArch = $(
  if ($osIsARM) { 'arm' } else { 'x' }
) + $(
  if ($osIs64Bit) { '64' } elseif (-Not $osIsARM) { '86' }
)

$apps | ForEach-Object {
    $vendor, $app = $_.Split(".")

    winget list --exact --id $_ | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Output "$app from $vendor is already installed"
    }
    else {
        Write-Output "Installing $app from $vendor"
        if ($osIsARM) {
            winget install --exact --id $_ --accept-source-agreements --accept-package-agreements --disable-interactivity --architecture $osArch
        } else {
            winget install --exact --id $_ --accept-source-agreements --accept-package-agreements --disable-interactivity
        }
        if ($LASTEXITCODE -eq 0) {
            Write-Output "$app from $vendor installed successfully."
        }
        else {
            Write-Output "Failed to install $app from $vendor."
        }
    }
}

Write-Output "🔧 Installing tooling - Files..."
Add-AppxPackage -AppInstallerFile https://cdn.files.community/files/stable/Files.Package.appinstaller

Write-Output "🔧 Installing tooling - Fantastical..."
Add-AppxPackage -AppInstallerFile https://cdn.flexibits.com/fantastical-windows/Fantastical.App_x64.appinstaller

Write-Output "🔧 Installing tooling - Visual Studio 2022 components..."
# https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2022&preserve-view=true
winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--norestart --passive --wait --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.NativeDesktop--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000"

gsudo config CacheMode Auto

Write-Output "🔧 Installing tooling - scoop..."
scoop checkup

# prerequisites for sudo to run smoothly
# - install sudo, innounp (innosetup unpacker), dark (wix unpacker), gsudo
scoop install main/sudo main/innounp main/dark main/gsudo
# - enable long paths
sudo Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
# - enable development mode
sudo Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1 -Verbose

scoop bucket add main
scoop bucket add extras
scoop bucket add java
scoop bucket add sysinternals
scoop bucket add versions
scoop bucket add games
scoop bucket add nerd-fonts

$scoopApps = @(
    "main/pwsh", # shell
    "main/eza", # ls replacement
    "main/bat", # cat replacement
    "main/fzf", # fuzzy finder
    "main/fd", # find replacement
    "main/btop", # top replacement
    "main/jq", # json processor
    "main/yq", # yaml, json and xml processor
    "main/fx", # json viewer
    "main/ripgrep", # grep replacement
    "main/delta", # diff viewer
    "main/perl", # scripting
    "main/diff-so-fancy", # diff viewer
    "main/xh", # curl replacement
    "main/starship", # prompt
    "main/zoxide", # cd replacement
    "main/git", # version control
    "extras/git-credential-manager", # secure git credential storage
    "main/procs", # ps replacement
    "main/dust", # du replacement
    "main/duf", # df replacement
    "main/chezmoi", # dotfiles manager
    "main/iperf3", # network speed test
    "main/1password-cli", # password manager
    "extras/lazygit", # git ui
    "main/topgrade", # update all the things
    "main/neovim", # text editor
    "main/neofetch", # system info
    "main/ntfy", # notifications
    "extras/mpv", # media player
    "extras/telegram", # messaging
    "extras/signal", # messaging
    "extras/discord", # messaging
    "extras/zoom", # video conferencing
    "main/clink", # powerful bash-style command line editing for cmd.exe
    "main/clink-completions", # completions for clink
    "main/scoop-search", # search for apps in scoop
    "main/syncthing", # file sync
    "extras/syncthingtray", # syncthing tray
    "extras/alacritty", # terminal
    "extras/everything", # fast file search
    "extras/flow-launcher", # app launcher
    "extras/calibre", # ebook manager  
    "extras/peazip", # archiver
    "main/7zip", # archiver
    "extras/winscp", # sftp client
    "extras/picpick", # screen capture
    "extras/thunderbird", # email client
    "extras/paint.net", # image editor
    "extras/musescore", # music notation
    "games/steam" # steam
    "extras/sharpkeys", # remap keys
    "main/usql", # universal sql client
    "main/aws", # aws cli
    "main/aws-iam-authenticator", # aws k8s auth
    "main/aws-ecs", # aws ecs tooling
    "main/k9s", # k8s ui
    "main/kubectl", # k8s cli
    "main/helm", # k8s package manager
    "main/stern", # k8s log viewer
    "main/kubectx", # k8s context manager
    "main/dive", # docker container image explorer
    "main/ctop", # container top
    "main/exiftool", # image metadata tool
    "main/scc", # code counter with complexity calculations and cocomo estimates
    "main/hyperfine", # cli benchmarking tool
    "main/hadolint", # dockerfile linter
    "main/gh", # github cli
    "main/glab", # gitlab cli
    "main/jj", # jujutsu — git compatible dvcs that is both simple and powerful
    "main/uv", # python package manager
    "main/direnv", # env manager
    "extras/jd-gui", # java decompiler
    "extras/keystore-explorer", # java keystore manager
    "java/temurin11-jdk", # java
    "java/temurin17-jdk", # java
    "java/temurin21-jdk", # java
    "main/maven", # build tool
    "main/gradle", # build tool
    "main/pandoc", # document converter
    "main/graphviz", # graph tool
    "extras/googlechrome", # browser
    "extras/firefox", # browser
    "extras/brave", # browser
    "extras/wireshark", # network protocol analyzer
    "extras/sd-card-formatter", # sd card formatter
    "extras/localsend", # file transfer
    "sysinternals/sysinternals-suite", # sysinternals suite
    "versions/vscode-insiders", # code editor
    "versions/zed-nightly", # code editor
    "nerd-fonts/Hack-NF" # nerd font
)

clink autorun install

$scoopApps | ForEach-Object {
    scoop install $_
}
