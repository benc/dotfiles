
Import-Module PSColor

# Direnv
if (Get-Command direnv -errorAction SilentlyContinue) {
  Invoke-Expression "$(direnv hook pwsh)"
  
  $env:DIRENV_CONFIG = $env:APPDATA + '\direnv\config'
}

# Zoxide
if (Get-Command zoxide -errorAction SilentlyContinue) {
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# Starship
if (Get-Command starship -errorAction SilentlyContinue) {
  Invoke-Expression (&starship init powershell)
}

# FZF
if (Get-Command fzf -errorAction SilentlyContinue) {
  if (-not (Get-Module -Name PSReadLine)) {
    # If not loaded, import the module
    Import-Module PSReadLine
  }
 
  Set-PSReadLineOption -EditMode Emacs
  Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

  Import-Module PSFzf
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+o' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# Chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
