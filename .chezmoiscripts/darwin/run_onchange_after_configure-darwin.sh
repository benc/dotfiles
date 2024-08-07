#!/bin/bash
echo "🔧 Setting a couple of macos defaults..."

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40 >> /dev/null

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "nl" "en" >> /dev/null
defaults write NSGlobalDomain AppleLocale -string "nl_BE@currency=EUR" >> /dev/null
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters" >> /dev/null
defaults write NSGlobalDomain AppleMetricUnits -bool true >> /dev/null

# Always use exapnded print dialog
defaults write -g PMPrintingExpandedStateForPrint -bool TRUE >> /dev/null

# Enable SSH
sudo systemsetup -setremotelogin on

# Never go into computer sleep mode
sudo systemsetup -setcomputersleep Off > /dev/null >> /dev/null

# Hibernate mode 3: Copy RAM to disk so the system state can still be restored in case of a power failure.
sudo pmset -a hibernatemode 3 >> /dev/null

# Enable powernap
sudo pmset -a powernap 1 >> /dev/null

# Disable lowpowermode
sudo pmset -a lowpowermode 0 >> /dev/null

# Save screenshots to the ~/Pictures/Screenshots folder
mkdir -p "${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots" >> /dev/null

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true >> /dev/null
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true >> /dev/null

# Reduce menu bar spacing
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 10 >> /dev/null
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 10 >> /dev/null
