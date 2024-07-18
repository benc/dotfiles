function ..() { cd .. }

function Remove-JavaProcess($Id) {
    jps -l | Where-Object { $_ -match $Id } | ForEach-Object {
        $processid = ($_ -split '\s+')[0]
        Stop-Process -Id $processid -Force
    }
}

function Remove-NodeModules {
    Remove-Item -Path "node_modules" -Recurse -Force
    npm install
    npm prune
}

function Invoke-Eza {
    eza --icons=always
}

function Invoke-Mpvr($File) {
    & mpv --script-opts=360plugin-enabled=yes --panscan=1 --geometry=600x600 --volume=100 $File
}

function Invoke-Bat($File) {
    & bat --theme TwoDark --style=plain --paging never $File
}

New-Alias -Name codei -Value code-insiders
Set-Alias which Get-Command
Set-Alias jkill Remove-JavaProcess
Set-Alias nuke_modules Remove-NodeModules
Set-Alias ls Invoke-Eza 
Set-Alias mpvr Invoke-Mpvr
Set-Alias top btop
Set-Alias cat Invoke-Bat
