$modulesToInstall = @(
    "PSWindowsUpdate",
     "PSColor", 
     "CompletionPredictor", 
     "PSReadLine", 
     "PSFzf", 
     "PowerType"
)

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

foreach ($module in $modulesToInstall) {
    Install-Module -Name $module
}
