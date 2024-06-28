Write-Host "Update winget packages"
winget import -i .winget.json --accept-source-agreements --accept-package-agreements --disable-interactivity
winget upgrade --all --accept-source-agreements --accept-package-agreements --silent --include-unknown

# miniconda cannot be updated with winget, needs to be done with conda itself
conda update -c base conda -y
