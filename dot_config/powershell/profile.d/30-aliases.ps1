New-Alias -Name codei -Value code-insiders
Set-Alias which Get-Command

function jkill ($Id) {
    jps -l | Where-Object { $_ -match $Id } | ForEach-Object {
        $pid = ($_ -split '\s+')[0]
        Stop-Process -Id $pid -Force
    }
}

function nuke_modules {
    Remove-Item -Path "node_modules" -Recurse -Force
    npm install
    npm prune
}
