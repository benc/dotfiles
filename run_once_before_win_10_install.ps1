$apps = @(
    "AgileBits.1Password", 
    "AgileBits.1Password.CLI",
    "ScooterSoftware.BeyondCompare4",
    "Microsoft.Sysinternals.ProcessExplorer",
    "Microsoft.WindowsTerminal",
    "JetBrains.Toolbox",
    "SaaSGroup.Tower", 
    "WinSCP.WinSCP",
    "Giorgiotani.Peazip", 
    "Intel.IntelDriverAndSupportAssistant", 
    "Docker.DockerDesktop",
    "Proxyman.Proxyman",
    "Microsoft.VisualStudioCode.Insiders",
    "Microsoft.VisualStudio.2022.Community"
    "Git.Git",
    "gerardog.gsudo",
    "tailscale.tailscale", 
    "IVPN.IVPN", 
    "Logitech.LogiTune", 
    "RandyRants.SharpKeys",
    "Flow-Launcher.Flow-Launcher", 
    "Mozilla.Firefox", 
    "Mozilla.Thunderbird", 
    "Alacritty.Alacritty",
    "Anaconda.Miniconda3",
    "JohnMacFarlane.Pandoc",
    "Amazon.AWSCLI",
    "junegunn.fzf",
    "ajeetdsouza.zoxide",
    "ducaale.xh",
    "BurntSushi.ripgrep.MSVC",
    "OliverBetz.ExifTool",
    "sharkdp.bat",
    "astral-sh.uv",
    "Derailed.k9s",
    "topgrade-rs.topgrade",
    "prefix-dev.pixi",
    "KaiKramer.KeyStoreExplorer",
    "LMStudio.LMStudio"
)

$apps | ForEach-Object {
    $vendor, $app = $_.Split(".")

    winget list --exact --id $_ | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Output "$app from $vendor is already installed"
    } else {
        Write-Output "Installing $app from $vendor"
        winget install --exact --id $_ --accept-source-agreements --accept-package-agreements --disable-interactivity
        if ($LASTEXITCODE -eq 0) {
            Write-Output "$app from $vendor installed successfully."
        } else {
            Write-Output "Failed to install $app from $vendor."
        }
    }
}

# https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2022&preserve-view=true
winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--norestart --passive --wait --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.NativeDesktop--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000"

gsudo config CacheMode Auto

scoop install aws-iam-authenticator direnv eza mpv btop

gsudo {
    & {{ .chezmoi.sourceDir }}/scripts/powershell/install.ps1
    
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
        -replace '#PubkeyAuthentication yes', 'PubkeyAuthentication yes' `
        -replace '#PasswordAuthentication yes', 'PasswordAuthentication no' `
        -replace 'Match Group administrators', '#Match Group administrators' `
        -replace 'AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys', '#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys') | Set-Content -Path C:\ProgramData\ssh\sshd_config

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

    $username = [Environment]::UserName

    # autostart wsl2 on boot
    $Action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-ExecutionPolicy Bypass -File `"$env:USERPROFILE\Documents\Scripts\run_wsl2_at_startup.ps1`""
    $Trigger = New-ScheduledTaskTrigger -AtLogOn -User $username
    $Trigger.Delay = "PT15S" # 15 second delay
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
    $Principal = New-ScheduledTaskPrincipal -UserId $username -LogonType Interactive -RunLevel Highest
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
    Register-ScheduledTask "Start WSL2" -InputObject $Task -Force

    # proxy wsl2 ssh on boot
    $Action = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument "-ExecutionPolicy Bypass -File `"$env:USERPROFILE\Documents\Scripts\proxy_wsl2.ps1`""
    $Trigger = New-ScheduledTaskTrigger -AtLogon -User $username
    $Trigger.Delay = "PT30S" # 30 second delay
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
    $Principal = New-ScheduledTaskPrincipal -UserId $username -LogonType Interactive -RunLevel Highest
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
    Register-ScheduledTask "Route WSL2 SSH" -InputObject $Task -Force

    # autostart docker on boot
    $Action = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument "-ExecutionPolicy Bypass -File `"$env:USERPROFILE\Documents\Scripts\run_docker_at_startup.ps1`""
    $Trigger = New-ScheduledTaskTrigger -AtLogon -User $username
    $Trigger.Delay = "PT10S" # 10 second delay
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
    $Principal = New-ScheduledTaskPrincipal -UserId $username -LogonType Interactive -RunLevel Highest
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
    Register-ScheduledTask "Start Docker Desktop" -InputObject $Task -Force

    # add user to docker-users group
    try {
        Add-LocalGroupMember -Group docker-users -Member $username -ErrorAction Stop
    }
    catch [Microsoft.PowerShell.Commands.MemberExistsException] {
    }

    # hyperv
    DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V /all

    # set keyboard to en-us, with nl-be as language
    $CurrentList = Get-WinUserLanguageList
    $CurrentList.Clear()

    $Lang = New-WinUserLanguageList nl-BE
    $Lang[0].InputMethodTips.Clear()
    $Lang[0].InputMethodTips.Add("0409:00000409") # US QWERTY layout
    Set-WinUserLanguageList $Lang -Force

    Get-WinUserLanguageList
}

refreshenv
