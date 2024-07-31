Write-Output ""
Write-Output "Configuring system..."
Write-Output ""

gsudo {
    Write-Output "Disable old powershell..."
    Disable-WindowsOptionalFeature -Online -FeatureName "MicrosoftWindowsPowerShellv2" -NoRestart
    Disable-WindowsOptionalFeature -Online -FeatureName "MicrosoftWindowsPowerShellv2Root" -NoRestart

    Write-Output "Set keyboard to en-us, with nl-be as language..."
    $CurrentList = Get-WinUserLanguageList
    $CurrentList.Clear()

    $Lang = New-WinUserLanguageList nl-BE
    $Lang[0].InputMethodTips.Clear()
    $Lang[0].InputMethodTips.Add("0409:00000409") # US QWERTY layout
    Set-WinUserLanguageList $Lang -Force

    Write-Output "Current keyboard list..."
    Get-WinUserLanguageList
}
