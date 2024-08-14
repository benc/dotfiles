Write-Output "🔧 Run the latest portainer agent"
docker stop portainer_agent
docker rm portainer_agent
docker pull portainer/agent:latest
docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent:latest

Write-Output "🔧 Update all the things"
chezmoi upgrade
topgrade --yes
