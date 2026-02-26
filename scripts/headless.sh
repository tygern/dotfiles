#!/bin/bash

set -e

DOTFILES_DIR=$(cd "$(dirname "$0")/.." && pwd)

step() { printf "\n\033[1;32m==> %s\033[0m\n" "$1"; }

# --- Preflight ---

step "Checking Homebrew"
if ! command -v brew &>/dev/null; then
    printf "\033[0;31mHomebrew is not installed.\033[0m\n"
    echo "Install it at https://brew.sh, then re-run this script."
    exit 1
fi

# --- Homebrew packages ---

step "Installing Homebrew packages"
brew bundle --file "$DOTFILES_DIR/Brewfile.headless"

# --- Dotfiles ---

step "Copying dotfiles"
cp "$DOTFILES_DIR/config/.tmux-headless.conf" ~/.tmux.conf

# --- Power management ---

step "Configuring power management"

# Never sleep on power adapter
sudo pmset -c sleep 0

# Restart automatically after power failure
sudo pmset -a autorestart 1

# --- System preferences ---

step "Configuring system preferences"

# Desktop: black background
osascript -e 'tell application "System Events" to set picture of every desktop to "/Library/Desktop Pictures/Solid Colors/Black.png"'

# --- Manual steps ---

cat <<'EOF'

============================================
  Remaining manual steps:
============================================

  1. Set up a cloudflared tunnel:
     https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/get-started/create-remote-tunnel/
  2. Enable Screen Sharing via Remote Management:
     (System Settings > General > Sharing > Remote Management)
  3. Enable Remote Login (SSH):
     (System Settings > General > Sharing > Remote Login)
  4. Open Docker to complete installation

EOF
