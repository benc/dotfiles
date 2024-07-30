gsudo {
    # ssh
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Set-Service -StartupType Automatic -Name sshd

    $configFilePath = "$Env:ProgramData\ssh\sshd_config"

    $config = Get-Content $configFilePath

    ((Get-Content -path C:\ProgramData\ssh\sshd_config -Raw) `
        -replace '#PubkeyAuthentication yes', 'PubkeyAuthentication yes' `
        -replace '#PasswordAuthentication yes', 'PasswordAuthentication no' `
        -replace 'Match Group administrators', '#Match Group administrators' `
        -replace 'AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys', '#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys') | Set-Content -Path C:\ProgramData\ssh\sshd_config

    Set-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Users\Ben\scoop\shims\pwsh.exe" -Verbose

    Restart-Service sshd
    Get-Service ssh-agent

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

    # allow ollama to run on all interfaces
    setx OLLAMA_HOST "0.0.0.0" /M
    
    # firewall
    $ports = @{
        2222 = 'WSL2 SSHD'
        11434 = 'Ollama'
    }
    
    foreach ($port in $ports.Keys) {
        $displayName = $ports[$port]
    
        $outboundRuleExists = Get-NetFirewallRule -DisplayName $displayName -Direction Outbound -LocalPort $port -ErrorAction SilentlyContinue
        $inboundRuleExists = Get-NetFirewallRule -DisplayName $displayName -Direction Inbound -LocalPort $port -ErrorAction SilentlyContinue
    
        if (-not $outboundRuleExists) {
            New-NetFireWallRule -DisplayName $displayName -Direction Outbound -LocalPort $port -Action Allow -Protocol TCP
        }
    
        if (-not $inboundRuleExists) {
            New-NetFireWallRule -DisplayName $displayName -Direction Inbound -LocalPort $port -Action Allow -Protocol TCP
        }
    }

    # hyperv
    Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V" -NoRestart

    # set keyboard to en-us, with nl-be as language
    $CurrentList = Get-WinUserLanguageList
    $CurrentList.Clear()

    $Lang = New-WinUserLanguageList nl-BE
    $Lang[0].InputMethodTips.Clear()
    $Lang[0].InputMethodTips.Add("0409:00000409") # US QWERTY layout
    Set-WinUserLanguageList $Lang -Force

    Get-WinUserLanguageList

    # support long paths
    Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1

    # disable old powershell
    Disable-WindowsOptionalFeature -Online -FeatureName "MicrosoftWindowsPowerShellv2" -NoRestart
    Disable-WindowsOptionalFeature -Online -FeatureName "MicrosoftWindowsPowerShellv2Root" -NoRestart
}
