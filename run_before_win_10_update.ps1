Write-Host "Update all the things"
# winget upgrade --all --accept-source-agreements --accept-package-agreements --silent --include-unknown
chezmoi upgrade
topgrade
Write-Host("")

# miniconda cannot be updated with winget, needs to be done with conda itself
conda update -c base conda -y

Write-Host "Run the latest portainer agent"
docker stop portainer_agent
docker rm portainer_agent
docker pull portainer/agent:latest
docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent:latest
