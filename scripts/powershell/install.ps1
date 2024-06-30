$modulesToInstall = @("PSColor", "CompletionPredictor", "PSReadLine", "PSFzf", "PowerType", $(if ($IsWindows) { "PSWindowsUpdate" }))

foreach ($module in $modulesToInstall) {
    if ($null -ne $module) {
        if (Get-Module -ListAvailable -Name $module) {
            Update-Module -Name $module
        }
        else {
            Install-Module -Name $module -Scope CurrentUser -Force
        }
    }
}
