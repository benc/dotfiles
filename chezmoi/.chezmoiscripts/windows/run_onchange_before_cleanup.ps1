gsudo {
    Write-Output "🔧 Cleaning up Windows components we do not need..."

    $appsToRemove = @(
        "Clipchamp.Clipchamp",
        "Microsoft.BingNews",
        "Microsoft.BingWeather",
        "Microsoft.GamingApp",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.Microsoft3DViewer",
        "Microsoft.MicrosoftStickyNotes",
        "Microsoft.MixedReality.Portal",
        "Microsoft.MSPaint",
        "Microsoft.OutlookForWindows",
        "Microsoft.Paint",
        "Microsoft.People",
        "Microsoft.Todos_8wekyb3d8bbwe",
        "Microsoft.ScreenSketch",
        "Microsoft.SkypeApp",
        "Microsoft.StorePurchaseApp",
        "Microsoft.Windows.Photos",
        "Microsoft.WindowsAlarms",
        "Microsoft.WindowsCalculator",
        "Microsoft.WindowsCamera",
        "Microsoft.WindowsCommunicationsApps",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps",
        "Microsoft.WindowsSoundRecorder",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.YourPhone",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo"
    )

    foreach ($app in $appsToRemove) {
        $userApp = Get-AppxPackage $app -ErrorAction SilentlyContinue
        if ($userApp) {
            $userApp | Remove-AppxPackage
        }
    
        $allUsersApp = Get-AppxPackage -AllUsers $app -ErrorAction SilentlyContinue
        if ($allUsersApp) {
            $allUsersApp | Remove-AppxPackage
        }
    
        $provisionedApp = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq $app }
        if ($provisionedApp) {
            $provisionedApp | ForEach-Object {
                Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName
            }
        }
    }

    Write-Output "🔧 Disabling Windows features we do not want..."
    $featuresToDisable = @(
        "MicrosoftWindowsPowerShellv2", # old version of PowerShell
        "MicrosoftWindowsPowerShellv2Root" # old version of PowerShell
    )
    
    foreach ($feature in $featuresToDisable) {
        Disable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart
    }
}
