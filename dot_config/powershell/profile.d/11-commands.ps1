
Import-Module PSColor

# Direnv
if (Get-Command direnv -errorAction SilentlyContinue) {
  Invoke-Expression "$(direnv hook pwsh)"
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
  Import-Module PsFzf

  # PSReadLine configuration
  # Shows navigable menu of all options when hitting Tab
  Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

  # PsFzf configuration
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
  $env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --info=inline'
  # https://github.com/junegunn/fzf/wiki/Windows#relative-filepaths
  $env:FZF_DEFAULT_COMMAND = 'rg --files . 2> nul'
}

# Chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
