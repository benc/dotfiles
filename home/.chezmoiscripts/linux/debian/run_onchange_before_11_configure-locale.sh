#!/bin/bash
echo "💡 Setup locale"
LOCALE=nl_BE.UTF-8
sudo apt-get install -y locales locales-all && \
    sudo sed -i -e "s/# ${LOCALE} UTF-8/${LOCALE} UTF-8/" /etc/locale.gen && \
    sudo dpkg-reconfigure --frontend=noninteractive locales
