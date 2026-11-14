#!/bin/zsh
# 旧 Mac で使っていた値を元にしている。
set -eu

# キーボード: 長押しでアクセント候補を出さず、キーリピートにする
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

# Finder: 拡張子とパスバーを表示、.DS_Store をネットワーク/USB に作らない
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Dock: 自動で隠す、最近使ったアプリを出さない、サイズ 74
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 74

# スクリーンショット: iCloud Drive の Inbox に保存
IC="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
if [[ -d "$IC" ]]; then
  mkdir -p "$IC/00_Inbox/Screenshots"
  defaults write com.apple.screencapture location "$IC/00_Inbox/Screenshots"
fi

killall Dock Finder SystemUIServer 2>/dev/null || true
