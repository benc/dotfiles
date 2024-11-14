Write-Output "🔧 Cleaning up unwanted winget packages..."
$wingetToRemove = @(
    "IVPN.IVPN",
    "HaystackSoftwareLLC.Arq7"
)

foreach ($package in $wingetToRemove) {
    if (winget list --exact -q $package) {
        Write-Output "Removing winget package: $package"
        winget uninstall --exact --silent $package
    }
}

Write-Output "🔧 Cleaning up unwanted Scoop packages..."
$scoopToRemove = @(
    "extras/tailscale"
)

foreach ($package in $scoopToRemove) {
    if (scoop list | Select-String -Pattern "^$package\s") {
        Write-Output "Removing Scoop package: $package"
        scoop uninstall $package
    }
}
