
Import-Module PSColor

$env:XDG_CACHE_HOME = if ($env:HOME) { (Join-Path $env:HOME .cache) } elseif ($env:USERPROFILE) { (Join-Path $env:USERPROFILE .cache) }
$env:XDG_DATA_HOME = if ($env:HOME) { (Join-Path $env:HOME (Join-Path .local share)) } elseif ($env:USERPROFILE) { (Join-Path $env:USERPROFILE (Join-Path .local share)) }
$env:XDG_CONFIG_HOME = if ($env:HOME) { (Join-Path $env:HOME .config) } elseif ($env:USERPROFILE) { (Join-Path $env:USERPROFILE .config) }

New-Item -ItemType Directory -Force -Path $env:XDG_CACHE_HOME | Out-Null
New-Item -ItemType Directory -Force -Path $env:XDG_DATA_HOME | Out-Null
New-Item -ItemType Directory -Force -Path $env:XDG_CONFIG_HOME | Out-Null

# Direnv
if (Get-Command direnv -errorAction SilentlyContinue) {
  $env:DIRENV_CONFIG = if ($env:HOME) { (Join-Path $env:HOME (Join-Path .direnv config)) } elseif ($env:USERPROFILE) { (Join-Path $env:USERPROFILE (Join-Path .direnv config)) }
  New-Item -ItemType Directory -Force -Path $env:DIRENV_CONFIG | Out-Null

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
