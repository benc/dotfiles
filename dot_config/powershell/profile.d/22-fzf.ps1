# fzf
# if (Get-Command fzf -errorAction SilentlyContinue) {
#   Import-Module PSReadLine # before PSFzf
#   Import-Module PsFzf

#   # PSReadLine configuration
#   # Shows navigable menu of all options when hitting Tab
#   Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

#   # PsFzf configuration
#   Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
#   $env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --info=inline'
#   # https://github.com/junegunn/fzf/wiki/Windows#relative-filepaths
#   $env:FZF_DEFAULT_COMMAND = 'rg --files . 2> nul'
# }
