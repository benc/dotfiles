function ..() { Set-Location .. }

function jkill($Id) {
    jps -l | Where-Object { $_ -match $Id } | ForEach-Object {
        $processid = ($_ -split '\s+')[0]
        Stop-Process -Id $processid -Force
    }
}

function nuke_modules {
    Remove-Item -Path "node_modules" -Recurse -Force
    npm install
    npm prune
}

if (Get-Alias -Name ls -ErrorAction SilentlyContinue) {
    Remove-Alias -Name ls
}
function ls { eza --icons=always --group-directories-first --git $args }
function mpvr { mpv --script-opts=360plugin-enabled=yes --panscan=1 --geometry=600x600 --volume=100 $args }

New-Alias -Name codei -Value code-insiders
Set-Alias which Get-Command
function top { btop }

if (Get-Alias -Name cat -ErrorAction SilentlyContinue) {
    Remove-Alias -Name cat
}
function cat_replacement {bat --theme TwoDark --style=plain --paging never  $args}
Set-Alias -Name cat -Value cat_replacement -Description "Replace cat with bat"
