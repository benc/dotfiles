$modulesToInstall = @(
    "PSColor", 
    "CompletionPredictor",
    "PSReadLine", 
    "PSFzf", 
    "PowerType",
    $(if ($IsWindows) { "PSWindowsUpdate" }
    ))

foreach ($module in $modulesToInstall) {
    if ($null -ne $module -and -not (Get-Module -ListAvailable -Name $module)) {
        Install-Module -Name $module -Scope CurrentUser -AllowClobber -Force
    }
}
