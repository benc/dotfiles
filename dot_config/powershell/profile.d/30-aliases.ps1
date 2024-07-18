New-Alias -Name codei -Value code-insiders
Set-Alias which Get-Command

function Remove-JavaProcess($Id) {
    jps -l | Where-Object { $_ -match $Id } | ForEach-Object {
        $processid = ($_ -split '\s+')[0]
        Stop-Process -Id $processid -Force
    }
}

Set-Alias jkill Remove-JavaProcess

function Remove-NodeModules {
    Remove-Item -Path "node_modules" -Recurse -Force
    npm install
    npm prune
}

Set-Alias nuke_modules Remove-NodeModules

function Invoke-Eza {
    eza --icons=always
}

Set-Alias ls Invoke-Eza 
