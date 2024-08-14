# Pixi
if (Get-Command zoxide -errorAction SilentlyContinue) {
    (& pixi completion --shell powershell) | Out-String | Invoke-Expression
}
