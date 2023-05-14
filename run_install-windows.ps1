Write-Host "Request administrator access"
gsudo {
    Write-Host "Update choco packages and modules"
    choco upgrade all -y
    Update-Module

    Write-Host "`nInstall choco packages"
    choco install bat delta fd fzf lf ripgrep -y

    Write-Host "`nInstall modules"
    Install-Module git-aliases -Scope CurrentUser -Allowclobber
    Install-Module -Name PSFzf
    Install-Module posh-git -Scope CurrentUser -AllowClobber
    Install-Module -Name Terminal-Icons -Repository PSGallery

    Write-Host "`nSet execution policy"
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
}

# install hyperv
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V /all

# install wsl2
# wsl --install
# wsl --set-default-version 2

# wsl --update
# wsl --install -d Ubuntu

# Stop ubuntu
# wsl --stop -d Ubuntu
#

# Add .wslconfig script with:
#
# In elevated cmd, run
# netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=2222
# netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=2222 connectaddress=192.168.1.44 connectport=2222
# # netsh interface portproxy show all
# # netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=2222
# netsh advfirewall firewall add rule name="Open Port 2222 for WSL2" dir=in action=allow protocol=TCP localport=2222

# TODO setup SSH
#
# TODO add reg key to set shell to bash with a default wsl distro - so jetbrains remote works WITHOUT setting up SSH in WSL2!
# wsl --install -d Ubuntu
# wsl --set-default Ubuntu
# New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\WINDOWS\System32\bash.exe" -PropertyType String -Force

Write-Host "Update winget packages"
winget upgrade --all
Write-Host("")

function wingetInstallIfNotInstalled($id) {
    Write-Host("Install $id if not installed")
    winget list --exact --id $id || winget install --exact --id $id --interactive
    Write-Host("")
}

wingetInstallIfNotInstalled("AgileBits.1Password")
wingetInstallIfNotInstalled("zoxide")
wingetInstallIfNotInstalled("ScooterSoftware.BeyondCompare4")
wingetInstallIfNotInstalled("Microsoft.Sysinternals.ProcessExplorer")
wingetInstallIfNotInstalled("Microsoft.WindowsTerminal")
wingetInstallIfNotInstalled("JetBrains.Toolbox")
wingetInstallIfNotInstalled("SaaSGroup.Tower")
wingetInstallIfNotInstalled("WinSCP.WinSCP")
wingetInstallIfNotInstalled("Giorgiotani.Peazip")
wingetInstallIfNotInstalled("Microsoft.VisualStudioCode")
wingetInstallIfNotInstalled("Nvidia.GeForceExperience")
wingetInstallIfNotInstalled("Intel.IntelDriverAndSupportAssistant")
wingetInstallIfNotInstalled("Docker.DockerDesktop")
wingetInstallIfNotInstalled("Git.Git")
wingetInstallIfNotInstalled("gerardog.gsudo")
wingetInstallIfNotInstalled("tailscale.tailscale")
wingetInstallIfNotInstalled("OpenJS.NodeJS.LTS")
wingetInstallIfNotInstalled("Zoom.Zoom")
wingetInstallIfNotInstalled("IVPN.IVPN")
wingetInstallIfNotInstalled("Logitech.LogiTune")
