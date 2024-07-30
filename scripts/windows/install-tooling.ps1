$apps = @(
    "AgileBits.1Password",
    "BelgianGovernment.eIDViewer",
    "ScooterSoftware.BeyondCompare4",
    "Microsoft.WindowsTerminal",
    "JetBrains.Toolbox",
    "SaaSGroup.Tower", 
    "Intel.IntelDriverAndSupportAssistant", 
    "Docker.DockerDesktop",
    "Proxyman.Proxyman",
    "Microsoft.VisualStudio.2022.Community",
    "tailscale.tailscale", 
    "IVPN.IVPN", 
    "Logitech.LogiTune",
    "Anaconda.Miniconda3",
    "prefix-dev.pixi",
    "KaiKramer.KeyStoreExplorer",
    "Ollama.Ollama",
    "LMStudio.LMStudio"
)

$apps | ForEach-Object {
    $vendor, $app = $_.Split(".")

    winget list --exact --id $_ | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Output "$app from $vendor is already installed"
    }
    else {
        Write-Output "Installing $app from $vendor"
        winget install --exact --id $_ --accept-source-agreements --accept-package-agreements --disable-interactivity --architecture $env:PROCESSOR_ARCHITECTURE
        if ($LASTEXITCODE -eq 0) {
            Write-Output "$app from $vendor installed successfully."
        }
        else {
            Write-Output "Failed to install $app from $vendor."
        }
    }
}

Add-AppxPackage -AppInstallerFile https://cdn.files.community/files/stable/Files.Package.appinstaller

# https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2022&preserve-view=true
winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--norestart --passive --wait --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.NativeDesktop--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000"

gsudo config CacheMode Auto

scoop checkup

scoop bucket add main
scoop bucket add extras
scoop bucket add java
scoop bucket add sysinternals
scoop bucket add versions
scoop bucket add games

$scoopApps = @(
    "main/7zip",
    "main/git",
    "main/pwsh",
    "main/chezmoi",
    "main/1password-cli",
    "main/gsudo",
    "main/dark",
    "main/innounp",
    "main/aws",
    "main/direnv",
    "main/eza",
    "main/pandoc",
    "main/k9s",
    "main/uv",
    "main/bat",
    "main/xh",
    "main/fzf",
    "main/zoxide",
    "main/ripgrep",
    "main/exiftool",
    "main/jq",
    "main/maven",
    "main/gradle",
    "main/neovim",
    "main/clink",
    "main/scoop-search",
    "extras/mpv",
    "extras/alacritty",
    "extras/everything",
    "extras/flow-launcher",
    "extras/sharpkeys",
    "extras/peazip",
    "extras/winscp",
    "extras/picpick",
    "extras/thunderbird",
    "extras/wireshark",
    "extras/sd-card-formatter",
    "extras/localsend",
    "extras/xpipe",
    "main/btop",
    "main/starship",
    "main/topgrade",
    "sysinternals/sysinternals-suite",
    "versions/vscode-insiders",
    "java/temurin11-jdk",
    "java/temurin17-jdk",
    "java/temurin21-jdk",
    "games/steam"
)

clink autorun install

$scoopApps | ForEach-Object {
    scoop install $_
}

sudo scoop install games/epic-games-launcher
