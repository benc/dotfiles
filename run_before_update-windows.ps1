gsudo {
  Write-Host "Update choco packages and modules"
  choco upgrade all -y
  Update-Module
}

Write-Host "Update winget packages"
winget upgrade --all
Write-Host("")
