
Import-Module PSColor

if (-not $env:HOME) {
  $env:HOME = $env:USERPROFILE
}

$env:XDG_CACHE_HOME = Join-Path $env:HOME ".cache"
$env:XDG_DATA_HOME = Join-Path $env:HOME (Join-Path ".local" "share")
$env:XDG_CONFIG_HOME = Join-Path $env:HOME ".config"

if (-not (Test-Path $env:XDG_CACHE_HOME)) { New-Item -ItemType Directory -Path $env:XDG_CACHE_HOME | Out-Null }
if (-not (Test-Path $env:XDG_DATA_HOME)) { New-Item -ItemType Directory -Path $env:XDG_DATA_HOME | Out-Null }
if (-not (Test-Path $env:XDG_CONFIG_HOME)) { New-Item -ItemType Directory -Path $env:XDG_CONFIG_HOME | Out-Null }

# Direnv
if (Get-Command direnv -errorAction SilentlyContinue) {
  $env:DIRENV_CONFIG = Join-Path $env:HOME (Join-Path .direnv config)
  if (-not (Test-Path $env:DIRENV_CONFIG )) { New-Item -ItemType Directory -Path $env:DIRENV_CONFIG | Out-Null }

  Invoke-Expression "$(direnv hook pwsh)"
}

# Zoxide
if (Get-Command zoxide -errorAction SilentlyContinue) {
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# Scoop
if (Get-Command scoop -errorAction SilentlyContinue) {
  Invoke-Expression (&scoop-search --hook)
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
