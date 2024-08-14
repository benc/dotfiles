# shellcheck shell=bash

export INSTALLATION_TYPE
export MACHINE_TYPE

INSTALLATION_TYPE=workstation
MACHINE_TYPE=unknown
MACHINE_TYPE_STRING=unknown

{{ if eq .chezmoi.os "darwin" }}
MACHINE_TYPE="macOS"
MACHINE_TYPE_STRING="$MACHINE_TYPE 🍎"
{{ else if eq .chezmoi.os "linux" }}
  {{ if eq .chezmoi.osRelease.id "debian" }}
    MACHINE_TYPE="Debian 🌀"
    MACHINE_TYPE_STRING="$MACHINE_TYPE 🌀"
  {{ else if eq .chezmoi.osRelease.id "ubuntu" }}
    MACHINE_TYPE="Ubuntu. 🎯"
    MACHINE_TYPE_STRING="$MACHINE_TYPE 🎯"
  {{ else if eq .chezmoi.osRelease.id "mint" }}
    MACHINE_TYPE="mint. 🌿"
    MACHINE_TYPE_STRING="$MACHINE_TYPE 🌿"
  {{ else }}
    echo "You are using a Linux distribution that is not supported by this script. 🐧"
    exit 1
  {{ end }}

  {{ if (.chezmoi.kernel.osrelease | lower | contains "microsoft") }}
  INSTALLATION_TYPE=wsl
  echo "Windows Subsystem for Linux 2 detected. 🪟🐧"
  {{ end }}
{{ end }}

{{ if eq (env "REMOTE_CONTAINERS") "true" }}
  INSTALLATION_TYPE=devcontainer
  echo "devcontainer detected. 🐳"
{{ else }}
  INSTALLATION_TYPE=workstation
{{ end }}

echo "You are using $MACHINE_TYPE_STRING, configuring it as '$INSTALLATION_TYPE'."
