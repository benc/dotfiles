#!/bin/bash
export INSTALLATION_TYPE
export MACHINE_TYPE

INSTALLATION_TYPE=workstation
MACHINE_TYPE=unknown
MACHINE_TYPE_STRING=unknown

set_machine_type_string() {
  case "$MACHINE_TYPE" in
    macOS)
      MACHINE_TYPE_STRING="$MACHINE_TYPE 🍎"
      ;;
    Debian)
      MACHINE_TYPE_STRING="$MACHINE_TYPE 🌀"
      ;;
    Ubuntu)
      MACHINE_TYPE_STRING="$MACHINE_TYPE 🎯"
      ;;
    mint)
      MACHINE_TYPE_STRING="$MACHINE_TYPE 🌿"
      ;;
    *)
      MACHINE_TYPE_STRING="unknown"
      ;;
  esac
}

OS=$(uname -s)
KERNEL_RELEASE=$(uname -r)

case "$OS" in
  Darwin)
    MACHINE_TYPE="macOS"
    ;;
  Linux)
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      case "$ID" in
        debian)
          MACHINE_TYPE="Debian"
          ;;
        ubuntu)
          MACHINE_TYPE="Ubuntu"
          ;;
        mint)
          MACHINE_TYPE="mint"
          ;;
        *)
          echo "You are using a Linux distribution that is not supported by this script. 🐧"
          exit 1
          ;;
      esac
    fi

    if echo "$KERNEL_RELEASE" | grep -qi "microsoft"; then
      INSTALLATION_TYPE=wsl
      echo "Windows Subsystem for Linux 2 detected. 🪟🐧"
    fi
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

set_machine_type_string

if [ "$REMOTE_CONTAINERS" = "true" ]; then
  INSTALLATION_TYPE=devcontainer
  echo "devcontainer detected. 🐳"
else
  INSTALLATION_TYPE=workstation
fi

echo "You are using $MACHINE_TYPE_STRING, configuring it as '$INSTALLATION_TYPE'."
