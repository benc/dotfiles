#!/bin/bash
echo "💡 Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

echo "💡 Installing prerequisites..."
sudo apt install -y \
    keychain \
    curl \
    build-essential \
    procps \
    file \
    git \
    ca-certificates \
    gnupg \
    lsb-release

echo "💡 Setup locale"
LOCALE=nl_BE.UTF-8
sudo apt-get install -y locales locales-all && \
    sudo sed -i -e "s/# ${LOCALE} UTF-8/${LOCALE} UTF-8/" /etc/locale.gen && \
    sudo dpkg-reconfigure --frontend=noninteractive locales

echo "💡 Installing 1Password CLI..."
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --batch --yes --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | sudo tee /etc/apt/sources.list.d/1password.list
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --batch --yes --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
sudo apt update && sudo apt install 1password-cli
