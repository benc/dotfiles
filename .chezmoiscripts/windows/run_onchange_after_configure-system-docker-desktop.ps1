Write-Output "🔧 Configuring Docker Desktop..."

gsudo {
    $username = [Environment]::UserName

    Write-Output "Autostart Docker on system startup..."
    $Action = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument "-ExecutionPolicy Bypass -File `"$env:USERPROFILE\Documents\Scripts\run_docker_at_startup.ps1`""
    $Trigger = New-ScheduledTaskTrigger -AtLogon -User $username
    $Trigger.Delay = "PT10S" # 10 second delay
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
    $Principal = New-ScheduledTaskPrincipal -UserId $username -LogonType Interactive -RunLevel Highest
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
    Register-ScheduledTask "Start Docker Desktop" -InputObject $Task -Force

    Write-Output "Add current user to 'docker-users' group..."
    try {
        Add-LocalGroupMember -Group docker-users -Member $username -ErrorAction Stop
    }
    catch [Microsoft.PowerShell.Commands.MemberExistsException] {
    }
}
