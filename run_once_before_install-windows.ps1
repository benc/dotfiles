function wingetInstallIfNotInstalled($id) {
    Write-Host("Install $id if not installed")
    winget list --exact --id $id || winget install --exact --id $id --interactive
    Write-Host("")
}

wingetInstallIfNotInstalled("AgileBits.1Password")
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
wingetInstallIfNotInstalled("IVPN.IVPN")
wingetInstallIfNotInstalled("Logitech.LogiTune")
wingetInstallIfNotInstalled("JanDeDobbeleer.OhMyPosh")
wingetInstallIfNotInstalled("RandyRants.SharpKeys")
wingetInstallIfNotInstalled("Flow-Launcher.Flow-Launcher")

Write-Host "Request administrator access"
gsudo {
    Write-Host "Update choco packages and modules"
    choco upgrade all -y
    Update-Module

    Write-Host "`nInstall choco packages"
    choco install bat delta fd fzf lf ripgrep op npiperelay zoxide awscli aws-iam-authenticator -y

    Write-Host "`nInstall modules"
    Install-Module -Name PSFzf

    Write-Host "`nSet execution policy"
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

    Write-Host "`nEnable Windows Developer Mode"
    Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1 -Verbose

    # ssh
    Add-WindowsCapability -Online -Name OpenSSH.Server
    Get-Service -Name sshd | Set-Service -StartupType Automatic

    $configFilePath = "$Env:ProgramData\ssh\sshd_config"

    $config = Get-Content $configFilePath

    $newConfig = $config | ForEach-Object {
        $line = $_
        if ($line -match "^#?PubkeyAuthentication") {
            $line = "PubkeyAuthentication yes"
        }
        elseif ($line -match "^#?PasswordAuthentication") {
            $line = "PasswordAuthentication no"
        }
        return $line
    }

    $newConfig | Out-File -Encoding utf8 $configFilePath

    $authorizedKeys = & op document get bcyfxsdxcjbaselrwoqyicavgi

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to run 'op' command"
        exit $LASTEXITCODE
    }

    $authorizedKeysPath = "$Env:ProgramData\ssh\administrators_authorized_keys"
    $authorizedKeys | Set-Content -Path $authorizedKeysPath


    Restart-Service sshd
    Get-Service ssh-agent

    # hyperv
    DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V /all

    # # allow port forwarding for jetbrains gateway in WSL2
    # $Port = 2222

    # New-NetFireWallRule -DisplayName 'WSL 2 Jetbrains Gateway Unlock' -Direction Outbound -LocalPort $Port -Action Allow -Protocol TCP
    # New-NetFireWallRule -DisplayName 'WSL 2 Jetbrains Gateway Unlock' -Direction Inbound -LocalPort $Port -Action Allow -Protocol TCP

    # netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=$Port
    # netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=$Port connectaddress=192.168.1.44 connectport=2222
    # netsh interface portproxy show v4tov4

    # ALTERNATIVE SOLUTION (easier) when Jetbrains Gateway supports SSHing into a Windows box https://www.jetbrains.com/help/idea/prerequisites.html
    Set-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\PowerShell\7\pwsh.exe" -Verbose
}

refreshenv

# wsl2
wsl --update
wsl --set-default-version 2 # always use wsl2
