# Machine setup

## Before running the script

1. Sign in to work account
1. Sign in to iCloud
1. Install command line tools: `xcode-select --install`
1. Install [Homebrew](https://brew.sh/)
1. Clone this repo
   ```shell
   mkdir -p ~/workspace/dotfiles
   git clone https://github.com/tygern/dotfiles.git ~/workspace/dotfiles
   ```

## Run the script

```shell
cd ~/workspace/dotfiles
./scripts/setup.sh <machine-name>
```

The script will prompt for your password when needed.

## After running the script

1. Log out and back in for all system preference changes to take effect
1. Menu bar: show Sound (System Settings > Control Center)
1. Keyboard: remove Cmd-Shift-A and Cmd-Shift-M shortcuts (System Settings > Keyboard > Keyboard Shortcuts)
1. Finder: add Home and ~/workspace to sidebar, remove others
1. Paste SSH public key (copied to clipboard by the script) into GitHub: https://github.com/settings/keys
1. JetBrains settings:
   - Editor font size 15
   - Tab limit 4
   - Disable parameter name hints
   - Remove status bar and navigation bar
