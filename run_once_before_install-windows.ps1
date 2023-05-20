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

    ((Get-Content -path C:\ProgramData\ssh\sshd_config -Raw) `
    -replace '#PubkeyAuthentication yes','PubkeyAuthentication yes' `
    -replace '#PasswordAuthentication yes','PasswordAuthentication no' `
    -replace 'Match Group administrators','#Match Group administrators' `
    -replace 'AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys','#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys') | Set-Content -Path C:\ProgramData\ssh\sshd_config

    Set-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\PowerShell\7\pwsh.exe" -Verbose

    Restart-Service sshd
    Get-Service ssh-agent

    # allow wsl2 ssh port forwarding
    $Port = 2222

    New-NetFireWallRule -DisplayName 'WSL2 SSHD' -Direction Outbound -LocalPort $Port -Action Allow -Protocol TCP
    New-NetFireWallRule -DisplayName 'WSL2 SSHD' -Direction Inbound -LocalPort $Port -Action Allow -Protocol TCP

    $wsl_ip = (wsl hostname -I).trim()
    Write-Host "WSL Machine IP: ""$wsl_ip"""
    netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=$Port
    netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=$Port connectaddress=$wsl_ip connectport=2222
    netsh interface portproxy show v4tov4

    # autostart wsl2 on boot
    $Action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "$env:USERPROFILE\Documents\Scripts\run_wsl2_at_startup.vbs"
    $username = [Environment]::UserName
    $Trigger = New-ScheduledTaskTrigger -AtLogOn -User $username
    $Trigger.Delay = "PT15S" # 15 second delay
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
    $Principal = New-ScheduledTaskPrincipal -UserId $username -LogonType Interactive -RunLevel Highest
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
    Register-ScheduledTask "Start WSL2" -InputObject $Task -Force

    # proxy wsl2 ssh on boot
    $Action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-ExecutionPolicy Bypass -File `"$env:USERPROFILE\Documents\proxy_wsl2.ps1`""
    $username = [Environment]::UserName
    $Trigger = New-ScheduledTaskTrigger -AtLogon -User $username
    $Trigger.Delay = "PT30S" # 30 second delay
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
    $Principal = New-ScheduledTaskPrincipal -UserId $username -LogonType Interactive -RunLevel Highest
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
    Register-ScheduledTask "Route WSL2 SSH" -InputObject $Task -Force

    # hyperv
    DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V /all
}

refreshenv

# wsl2
wsl --update
wsl --set-default-version 2 # always use wsl2
