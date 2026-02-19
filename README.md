# Machine setup

## Before running the script

1. Sign in to work account
1. Sign in to iCloud
1. Install command line tools
   ```shell
   xcode-select --install
   ```
1. Install [Homebrew](https://brew.sh/)
   ```shell
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
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

Follow the remaining manual steps printed by the script.
