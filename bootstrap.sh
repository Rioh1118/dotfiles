#!/bin/zsh
# 新しい Mac で 1 回実行する。何度実行しても壊れないように書いてある。
#   git clone https://github.com/Rioh1118/dotfiles.git ~/dotfiles && ~/dotfiles/bootstrap.sh
set -euo pipefail

DOT="${0:A:h}"
STOW_PKGS=(zsh git nvim tmux wezterm starship yazi bat mise)

step() { print -P "\n%F{cyan}==> $1%f"; }

[[ "$(uname -m)" == "arm64" ]] || { echo "arm64 の Mac 専用です"; exit 1; }

step "Xcode Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "インストールが終わったら、もう一度このスクリプトを実行してください"
  exit 0
fi

step "Homebrew (/opt/homebrew)"
if [[ ! -x /opt/homebrew/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file="$DOT/Brewfile"

step "dotfiles をリンク (stow)"
# 新しい Mac に最初からある ~/.zshrc 等は退避してからリンクする
for f in .zshrc .zprofile .zshenv; do
  if [[ -e "$HOME/$f" && ! -L "$HOME/$f" ]]; then mv "$HOME/$f" "$HOME/$f.pre-dotfiles"; fi
done
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share"
stow -d "$DOT" -t "$HOME" --restow "${STOW_PKGS[@]}"
# ~/.local と ~/.claude は他のツールがデータを書き込むので、ディレクトリごとではなくファイル単位でリンクする
mkdir -p "$HOME/.claude"
stow -d "$DOT" -t "$HOME" --restow --no-folding bin claude

step "ランタイム (mise / rustup)"
mise install
if [[ ! -x "$HOME/.cargo/bin/rustup" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

step "tmux プラグイン (TPM)"
TPM_DIR="$HOME/.local/share/tmux/plugins/tpm"
[[ -d "$TPM_DIR" ]] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
# install_plugins は動いている tmux サーバーから設定を読むので、一時セッションを立てる
tmux new-session -d -s __bootstrap
"$TPM_DIR/bin/install_plugins"
tmux kill-server 2>/dev/null || true

step "bat のテーマ"
bat cache --build >/dev/null

step "macOS の設定"
"$DOT/macos/defaults.sh"

step "Downloads 自動整理 (launchd)"
PLIST="$HOME/Library/LaunchAgents/com.local.sweep-downloads.plist"
sed "s|__HOME__|$HOME|g" "$DOT/launchd/com.local.sweep-downloads.plist" > "$PLIST"
launchctl bootout "gui/$(id -u)" "$PLIST" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST"

step "完了"
echo "新しいターミナルを開いて 'time zsh -i -c exit' で起動時間を確認してください"
