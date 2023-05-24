$configPath = "~/.config/powershell/profile_d"

if (Test-Path $configPath) {
    $configFiles = Get-ChildItem -Path $configPath -Filter "*.ps1" -File

    foreach ($file in $configFiles) {
        . $file.FullName
    }
}
