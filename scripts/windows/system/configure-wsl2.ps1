Write-Output ""
Write-Output "Configuring WSL2..."
Write-Output ""

gsudo {
    $username = [Environment]::UserName
    $wslIp = (wsl hostname -I).trim()
    $wslSshPort = 2222
    $displayName = 'WSL2 SSHD'

    Write-Output "Enable Hyper-V..."
    Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V" -NoRestart

    Write-Output "Configuring WSL machine so we can access it directly through SSH..."
    Write-Host "WSL Machine IP: ""$wslIp"""
    netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=$wslSshPort
    netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=$wslSshPort connectaddress=$wslIp connectport=$wslSshPort
    netsh interface portproxy show v4tov4

    Write-Output "Configuring WSL2 to start on boot..."
    $Action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-ExecutionPolicy Bypass -File `"$env:USERPROFILE\Documents\Scripts\run_wsl2_at_startup.ps1`""
    $Trigger = New-ScheduledTaskTrigger -AtLogOn -User $username
    $Trigger.Delay = "PT15S" # 15 second delay
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
    $Principal = New-ScheduledTaskPrincipal -UserId $username -LogonType Interactive -RunLevel Highest
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
    Register-ScheduledTask "Start WSL2" -InputObject $Task -Force

    Write-Output "Configuring WSL2 SSH proxy to start on boot..."
    $Action = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument "-ExecutionPolicy Bypass -File `"$env:USERPROFILE\Documents\Scripts\proxy_wsl2.ps1`""
    $Trigger = New-ScheduledTaskTrigger -AtLogon -User $username
    $Trigger.Delay = "PT30S" # 30 second delay
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
    $Principal = New-ScheduledTaskPrincipal -UserId $username -LogonType Interactive -RunLevel Highest
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
    Register-ScheduledTask "Route WSL2 SSH" -InputObject $Task -Force
    
    Write-Output "Configuring WSL2 SSH in Windows Firewall..."
    if (!(Get-NetFirewallRule -DisplayName $displayName -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
        New-NetFireWallRule -DisplayName $displayName -Direction Outbound -LocalPort $wslSshPort -Action Allow -Protocol TCP
        New-NetFireWallRule -DisplayName $displayName -Direction Inbound -LocalPort $wslSshPort -Action Allow -Protocol TCP
    } else {
        Write-Output "$displayName firewall rule is already configured"
    }
}
