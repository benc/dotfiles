$modulesToInstall = @(
    "PSColor", 
    "CompletionPredictor", 
    "PSReadLine", 
    "PSFzf", 
    "PowerType"
)

foreach ($module in $modulesToInstall) {
    Install-Module -Name $module
}

if ($IsWindows) {
    Install-Module -Name PSWindowsUpdate
}
