Write-Output "🔧 Installing tooling - winget..."

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

$scoopApps = @(
    "main/7zip",
    "main/git",
    "main/pwsh",
    "main/chezmoi",
    "main/1password-cli",
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
    "main/btop",
    "main/starship",
    "main/topgrade",
    "main/syncthing",
    "main/hadolint",
    "main/scc", # code counter with complexity calculations and cocomo estimates
    "main/delta",
    "main/fd",
    "extras/lazygit",
    "extras/git-credential-manager",
    "extras/mpv",
    "extras/alacritty",
    "extras/everything",
    "extras/flow-launcher",
    "extras/googlechrome",
    "extras/firefox",
    "extras/brave",
    "extras/calibre",
    "extras/sharpkeys",
    "extras/peazip",
    "extras/winscp",
    "extras/picpick",
    "extras/thunderbird",
    "extras/wireshark",
    "extras/sd-card-formatter",
    "extras/localsend",
    "extras/xpipe",
    "extras/paint.net",
    "extras/keystore-explorer",
    "extras/telegram",
    "extras/zoom",
    "extras/signal",
    "extras/discord",
    "extras/jd-gui",
    "extras/syncthingtray",
    "extras/musescore",
    "sysinternals/sysinternals-suite",
    "versions/vscode-insiders",
    "versions/zed-nightly",
    "java/temurin11-jdk",
    "java/temurin17-jdk",
    "java/temurin21-jdk",
    "games/steam"
)

clink autorun install

$scoopApps | ForEach-Object {
    scoop install $_
}
