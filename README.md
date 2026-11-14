# dotfiles

Apple Silicon の macOS 用。GNU stow でパッケージごとに `$HOME` へリンクする。

## 新しい Mac

```sh
xcode-select --install
git clone https://github.com/Rioh1118/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap.sh
```

鍵や Git 署名などの残りの作業は Claude Code に任せる。プロンプトは [docs/new-mac-setup-prompt.md](docs/new-mac-setup-prompt.md)。

## 構成

| パッケージ | リンク先 | 中身 |
|---|---|---|
| `zsh` | `~/.zshenv` `~/.zprofile` `~/.zshrc` `~/.config/zsh/` | oh-my-zsh なし。fzf-git.sh を同梱 |
| `git` | `~/.config/git/` | 共通設定。署名などマシン固有の値は `config.local` |
| `nvim` | `~/.config/nvim/` | lazy.nvim。`lazy-lock.json` もコミットする |
| `tmux` | `~/.config/tmux/` | TPM・resurrect・continuum。プラグインと保存データは `~/.local/share/tmux/` |
| `wezterm` | `~/.config/wezterm/` | 起動すると tmux の `main` セッションに入る |
| `starship` `yazi` `bat` `mise` | `~/.config/...` | |
| `bin` | `~/.local/bin/` | `sweep-downloads` など。`--no-folding` |
| `claude` | `~/.claude/` | `settings.json` と hooks だけ。`--no-folding` でファイル単位にリンクする |

stow しないもの: `Brewfile` `bootstrap.sh` `macos/` `launchd/` `docs/`

## 運用規則

1. **持ち込むのは設定ファイルだけ。** キャッシュ、`node_modules`、ビルド成果物、`~/Library` は移さない。
2. **データの置き場所は 4 つ。** コードは GitHub、秘密情報は暗号化ディスクイメージ（`secrets.dmg`、iCloud Drive に置く）、書類は iCloud Drive、それ以外は削除。
3. **Homebrew は `/opt/homebrew` だけ。** `brew install` したらその日のうちに Brewfile に追記する。月に 1 回 `brew bundle cleanup --file ~/dotfiles/Brewfile` で差分を確認する。
4. **ランタイムは mise。** Python は uv、Rust は rustup。nvm・pyenv・rbenv・goenv・anyenv・conda は使わない。
5. **秘密情報はコミットしない。** このリポジトリは public。マシン固有の値は `~/.zshrc.local` と `~/.config/git/config.local` に書く。
6. **設定を変えたらその日のうちにコミットする。**

## tmux の自動保存と復元

- continuum が 5 分ごとに保存する（`~/.local/share/tmux/resurrect/`）
- tmux サーバーが起動したときに、最後に保存した状態を自動で復元する
- WezTerm は起動時に `tmux new-session -A -s main` を実行するので、再起動後も WezTerm を開けば元の状態に戻る
- tmux を通さずにシェルを開きたいときは WezTerm で `Cmd+Shift+N`
- 手動の保存は `prefix + Ctrl-s`、手動の復元は `prefix + Ctrl-r`（prefix は `Ctrl-a`）
