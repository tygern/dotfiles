# Machine setup

1. Sign in to work account
1. Sign in to icloud account
1. Remove all icons from dock except finder, downloads, and trash
1. Auto hide dock
1. Always show sound in the menubar
1. Disable system sounds
1. Set keyboard to use F-keys
1. Increase key repeat speed to maximum and decrease delay to minimum
1. Remove Cmd-Shift-A and Cmd-Shift-M shortcuts
1. Remove all hot corners and quick corners
1. Create ~/workspace
1. Add home and workspace to finder sidebar, remove others
1. Install command line tools (`xcode-select --install`)
1. [Set machine name](https://gist.github.com/tygern/17779a4072373855a03d)
1. Install [Homebrew](https://brew.sh/)
1. `brew analytics off`
1. `brew install git wget watch tree jq tmux`
1. `brew install --cask keepingyouawake jetbrains-toolbox rectangle 1password zed docker`
1. Install dotfiles.
    ```shell
    cp ./config/.zshrc ~/.zshrc
    cp ./config/ghostty.config ~/Library/Application\ Support/com.mitchellh.ghostty/config
    mkdir -p ~/Library/Application\ Support/Rectangle
    cp ./config/RectangleConfig.json ~/Library/Application\ Support/Rectangle/RectangleConfig.json
    mkdir -p  ~/.config/zed
    cp ./config/zed-settings.json ~/.config/zed/settings.json
    ```
1. `echo "$HOME/bin" | sudo tee -a /etc/paths`
1. Create [github keys](https://github.com/settings/keys)
1. Jetbrains editor settings
   1. Size 15 editor font
   1. Tab limit 4
   1. Disable parameter name hints
   1. Remove status bar and navigation bar
