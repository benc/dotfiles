Write-Output "🔧 Configuring system..."

gsudo {
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
