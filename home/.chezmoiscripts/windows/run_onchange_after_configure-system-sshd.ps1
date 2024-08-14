Write-Output "🔧 Configuring OpenSSH Server..."

gsudo {
    Write-Output "Add OpenSSH Server Windows capability..."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

    Write-Output "Set sshd service to start automatically..."
    Set-Service -StartupType Automatic -Name sshd

    Write-Output "Adapt SSHD config so only SSH keys are accepted..."
    ((Get-Content -path "$Env:ProgramData\ssh\sshd_config" -Raw) `
        -replace '#PubkeyAuthentication yes', 'PubkeyAuthentication yes' `
        -replace '#PasswordAuthentication yes', 'PasswordAuthentication no' `
        -replace 'Match Group administrators', '#Match Group administrators' `
        -replace 'AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys', '#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys') | Set-Content -Path C:\ProgramData\ssh\sshd_config

    Write-Output "Configuring PowerShell Core as default SSH shell..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "$env:USERPROFILE\scoop\shims\pwsh.exe" -Verbose

    Write-Output "Restart ssh for changes to take effect..."
    Restart-Service sshd
    Get-Service ssh-agent
}
