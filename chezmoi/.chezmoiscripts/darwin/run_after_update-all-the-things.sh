#!/bin/bash
if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

echo "💡 Upgrade all the things..."
# chezmoi
chezmoi upgrade

if [ "$INSTALLATION_TYPE" = "server" ] || [ "$INSTALLATION_TYPE" = "workstation" ]; then
    # portainer
    if command -v docker >/dev/null 2>&1; then
        echo "💡 Updating portainer agent..."
        # Docker commands
        docker stop portainer_agent
        docker rm portainer_agent
        docker pull portainer/agent:latest
        docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent:latest
    else
        echo "⚠️ Docker is not installed or not found in the path. Please install Docker."
    fi
fi

# topgrade
topgrade || true
