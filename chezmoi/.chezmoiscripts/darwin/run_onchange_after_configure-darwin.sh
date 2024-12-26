#!/bin/bash
# https://macos-defaults.com/
if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/installation-type.sh
else
    echo "☢️  No installation type set, did you run this script directly? Set INSTALLATION_TYPE using an env var if needed."
fi

if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

darwin_check_full_disk_access() {
  if [ "$(uname -s)" = "Darwin" ]; then
    if ! plutil -lint /Library/Preferences/com.apple.TimeMachine.plist >/dev/null ; then
      log_error "This script requires your terminal app to have Full Disk Access. Add this terminal to the Full Disk Access list in System Preferences > Security & Privacy, quit the app, and re-run this script."
      open 'x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles'
      exit 1
    else
      echo "Your terminal has Full Disk Access"
    fi
  fi
}

darwin_check_full_disk_access

sudo -v

echo "🔧 Setting a couple of macos defaults..."

# >>> System <<<

# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "nl-BE" "en-BE" >> /dev/null
defaults write NSGlobalDomain AppleLocale -string "nl_BE@currency=EUR" >> /dev/null
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters" >> /dev/null
defaults write NSGlobalDomain AppleMetricUnits -bool true >> /dev/null

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Brussels" 2>/dev/null 1>&2

# Always use exapnded print dialog
defaults write -g PMPrintingExpandedStateForPrint -bool TRUE >> /dev/null

## Always use exanded save panel
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true >> /dev/null

# Enable SSH for admins
sudo systemsetup -setremotelogin on
if ! dseditgroup com.apple.access_ssh &> /dev/null; then
  dseditgroup -o create -q com.apple.access_ssh
fi
sudo dseditgroup -o edit -a admin -t group com.apple.access_ssh

# Enable ARD for admins
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
  -activate -configure -access -on -users admin -privs -all -restart -agent -menu

# Never go into computer sleep mode
# sudo systemsetup -setcomputersleep Off > /dev/null >> /dev/null
# TODO: this command returns an error when running the script in Sonoma

# Hibernate mode 3: Copy RAM to disk so the system state can still be restored in case of a power failure.
sudo pmset -a hibernatemode 3 >> /dev/null

# Enable powernap
sudo pmset -a powernap 1 >> /dev/null

# Disable lowpowermode
sudo pmset -a lowpowermode 0 >> /dev/null

# Reduce menu bar spacing
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 10 >> /dev/null
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 10 >> /dev/null

# Save screenshots to the ~/Pictures/Screenshots folder
mkdir -p "${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots" >> /dev/null

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40 >> /dev/null

# >>> Dock <<<

defaults write com.apple.dock orientation bottom >> /dev/null
defaults write com.apple.dock "mineffect" -string "genie" >> /dev/null
defaults write com.apple.dock magnification -bool true >> /dev/null
defaults write com.apple.dock largesize -int 71 >> /dev/null
defaults write com.apple.dock "show-recents" -bool "false" >> /dev/null

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# top right screen corner → Start screen saver + lock screen if screen saver is set
defaults write com.apple.dock wvous-tr-corner -int 5 >> /dev/null
defaults write com.apple.dock wvous-tr-modifier -int 0 >> /dev/null

killall Dock

# >>> Finder <<<

defaults write com.apple.finder ShowStatusBar -bool true >> /dev/null
defaults write com.apple.finder ShowPathBar -bool true >> /dev/null

# Preferred view style
# Icon View   : `icnv`
# List View   : `Nlsv`
# Column View : `clmv`
# Cover Flow  : `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" >> /dev/null

# After configuring preferred view style, clear all `.DS_Store` files
# to ensure settings are applied for every directory
find . -name '.DS_Store' -type f -delete

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true >> /dev/null

# New window target
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
# Other…       : `PfLo`
defaults write com.apple.finder NewWindowTarget -string 'PfHm' >> /dev/null

defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true >> /dev/null

# Desktop Enabled
defaults write com.apple.finder CreateDesktop -bool true >> /dev/null

# Show folders first on Desktop
defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true" >> /dev/null

# Icons for hard drives, servers, and removable media on the desktop (default: false)
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true >> /dev/null
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true >> /dev/null
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true >> /dev/null
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true >> /dev/null

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true >> /dev/null
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true >> /dev/null

# Enable airdrop over wired ethernet
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true >> /dev/null

# Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false >> /dev/null
defaults write com.apple.finder EmptyTrashSecurely -bool true >> /dev/null

# Set default search scope to current folder
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf" >> /dev/null

# Don't warn when changing file extensions
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false" >> /dev/null

# Always show icon in the titlebar
defaults write com.apple.universalaccess "showWindowTitlebarIcons" -bool "true" >> /dev/null

killall Finder

# >>> Disable stage manager <<<

# hide widgets in Stage Manager
defaults write com.apple.WindowManager StandardHideWidgets -bool true >> /dev/null
# auto-hide Stage Manager
defaults write com.apple.WindowManager AutoHide -bool true >> /dev/null
# disable standard click to show desktop
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false >> /dev/null
# hide desktop when using Stage Manager
defaults write com.apple.WindowManager HideDesktop -bool true >> /dev/null
# hide Stage Manager widgets
defaults write com.apple.WindowManager StageManagerHideWidgets -bool true >> /dev/null
# hide desktop icons in standard view
defaults write com.apple.WindowManager StandardHideDesktopIcons -bool true >> /dev/null

# >>> Menu bar <<<

defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "true" >> /dev/null
defaults write com.apple.menuextra.clock "DateFormat" -string "\"HH:mm\"" >> /dev/null

killall SystemUIServer

# >>> Safari <<<

defaults write com.apple.Safari ShowStatusBar -bool true >> /dev/null
defaults write com.apple.Safari ShowFavoritesBar-v2 -bool true >> /dev/null
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true >> /dev/null
defaults write com.apple.Safari CanPromptForPushNotifications -bool false >> /dev/null
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true >> /dev/null
defaults write com.apple.Safari IncludeDevelopMenu -bool true >> /dev/null
defaults write com.apple.Safari AutoFillFromAddressBook -bool false >> /dev/null
defaults write com.apple.Safari AutoFillPasswords -bool false >> /dev/null
defaults write com.apple.Safari AutoFillCreditCardData -bool false >> /dev/null
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false >> /dev/null

killall Safari

# >>> Specific settings for workstation/server <<<
if [ "$INSTALLATION_TYPE" = "server" ] || [ "$INSTALLATION_TYPE" = "workstation" ]; then
  # Require password immediately after sleep or screen saver begins
  # defaults write com.apple.screensaver askForPasswordDelay -int 0 >> /dev/null

  # Dark mode
  defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark" >> /dev/null
fi

# Amnesia
# defaults read ~/Library/Group\ Containers/group.com.apple.replayd/ScreenCaptureApprovals.plist
screenCaptureApps=(
  "/Applications/Setapp/CleanShot X.app/Contents/MacOS/CleanShot X Setapp"
  "/Applications/Setapp/QuickLens.app/Contents/MacOS/QuickLens"
  "/Applications/Setapp/Sip.app/Contents/MacOS/Sip"
  "/Applications/Microsoft Teams.app/Contents/MacOS/MSTeams"
  "/Applications/Microsoft Teams classic.app/Contents/MacOS/Teams"
  "/Applications/zoom.us.app/Contents/MacOS/zoom.us"
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  "/Applications/Ice.app/Contents/MacOS/Ice"
  "/Applications/Side Mirror.app/Contents/MacOS/Side Mirror"
)

approvalsFile="$HOME/Library/Group Containers/group.com.apple.replayd/ScreenCaptureApprovals.plist"

# if this fails, you prolly dont have full disk access for your terminal app enabled
for app in "${screenCaptureApps[@]}"; do
  defaults write "$approvalsFile" "$app" -date "3024-09-17 14:59:37 +0000"
done
