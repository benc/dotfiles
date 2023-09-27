#!/usr/bin/env bash
MACOS_VERSION=14 # = sonoma
MACOS_CATALOG=publicrelease # publicrelease, public, customer, developer
MACOS_INSTALLER_NAME="Install macOS Sonoma.app"
MACOS_INSTALLER_VOLUME_NAME="Install macOS Sonoma"

# download macos
cd /tmp || exit
git clone "https://github.com/corpnewt/gibMacOS"
./gibMacOS/gibMacOS.py -v $MACOS_VERSION -c $MACOS_CATALOG

# make it available
sudo installer -pkg gibMacOS/macOS\ Downloads/publicrelease/*/InstallAssistant.pkg -target /

# # create iso
hdiutil create -o /tmp/macOS -size 14800m -volname macOS -layout SPUD -fs HFS+J
hdiutil attach /tmp/macOS.dmg -noverify -mountpoint /Volumes/macOSISO
sudo "/Applications/$MACOS_INSTALLER_NAME/Contents/Resources/createinstallmedia" --volume "/Volumes/macOSISO" --nointeraction
hdiutil detach -force "/Volumes/$MACOS_INSTALLER_VOLUME_NAME"
hdiutil convert /tmp/macOS.dmg -format UDTO -o ~/Desktop/macOS.cdr
mv ~/Desktop/macOS.cdr ~/Desktop/macOS.iso

# housekeeping
cd /tmp/gibMacOS || exit
rm -rf gibMacOS macOS.dmg
