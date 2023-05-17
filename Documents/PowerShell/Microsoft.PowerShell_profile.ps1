#$executionTime = Measure-Command `
#{
Import-Module PSReadLine # before PSFzf
Import-Module PsFzf

# $ProfilePath=Split-Path -parent $profile

# PSReadLine configuration
# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# PsFzf configuration
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
$env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --info=inline'
# https://github.com/junegunn/fzf/wiki/Windows#relative-filepaths
$env:FZF_DEFAULT_COMMAND = 'rg --files . 2> nul'

# Zoxide: https://github.com/ajeetdsouza/Zoxide
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})

# Prompt
Invoke-Expression (&starship init powershell)

#}
#Write-Host "$PSCommandPath execution time: $executionTime"
