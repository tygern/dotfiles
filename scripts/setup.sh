#!/bin/bash

set -e

DOTFILES_DIR=$(cd "$(dirname "$0")/.." && pwd)

step() { printf "\n\033[1;32m==> %s\033[0m\n" "$1"; }
warn() { printf "\033[1;33mwarning:\033[0m %s\n" "$1"; }

if [[ $# -ne 1 ]]; then
    echo "Usage: setup.sh <machine-name>"
    exit 1
fi
NEW_NAME="$1"

# --- Preflight ---

step "Checking Homebrew"
if ! command -v brew &>/dev/null; then
    printf "\033[0;31mHomebrew is not installed.\033[0m\n"
    echo "Install it at https://brew.sh, then re-run this script."
    exit 1
fi

# --- Machine name ---

step "Setting machine name"
sudo scutil --set HostName "$NEW_NAME"
sudo scutil --set LocalHostName "$NEW_NAME"
sudo scutil --set ComputerName "$NEW_NAME"
echo "Machine name set to: $NEW_NAME"

# --- Homebrew packages ---

step "Installing Homebrew packages"
brew analytics off
brew bundle --file "$DOTFILES_DIR/Brewfile"

# --- Dotfiles ---

step "Copying dotfiles"
mkdir -p ~/workspace
cp "$DOTFILES_DIR/config/.zshrc" ~/.zshrc
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
cp "$DOTFILES_DIR/config/ghostty.config" ~/Library/Application\ Support/com.mitchellh.ghostty/config
mkdir -p ~/Library/Application\ Support/Rectangle
cp "$DOTFILES_DIR/config/RectangleConfig.json" ~/Library/Application\ Support/Rectangle/RectangleConfig.json
mkdir -p ~/.config/zed
cp "$DOTFILES_DIR/config/zed-settings.json" ~/.config/zed/settings.json

# --- /etc/paths ---

step "Adding ~/bin to /etc/paths"
echo "$HOME/bin" | sudo tee -a /etc/paths

# --- System preferences ---

step "Configuring system preferences"

# Dock: auto-hide
defaults write com.apple.dock autohide -bool true

# Dock: hot corners and quick corners (all off)
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-modifier -int 0
killall Dock

# Keyboard: use F-keys as standard function keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Keyboard: fastest key repeat and shortest delay
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Sound: disable UI sound effects
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

echo "Done. Some changes require logging out to take effect."

# --- Manual steps ---

cat <<'EOF'

============================================
  Remaining manual steps:
============================================

  1. Sign in to work account
  2. Sign in to iCloud
  3. Dock: remove all icons except Finder, Downloads, Trash
  4. Menu bar: show Sound (System Settings > Control Center)
  5. Keyboard: remove Cmd-Shift-A and Cmd-Shift-M shortcuts
     (System Settings > Keyboard > Keyboard Shortcuts)
  6. Finder: add Home and ~/workspace to sidebar, remove others
  7. Create GitHub SSH key: https://github.com/settings/keys
  8. JetBrains settings:
       - Editor font size 15
       - Tab limit 4
       - Disable parameter name hints
       - Remove status bar and navigation bar

EOF
