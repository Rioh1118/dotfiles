# 新しい Mac のセットアップ用プロンプト

新しい Mac で Claude Code を起動し、下の「プロンプト」の枠の中をそのまま貼り付ける。

## 貼り付ける前に自分でやること（4 つ）

1. macOS の初期設定。「移行アシスタント」は使わない。iCloud Drive はオン、「デスクトップと書類フォルダ」はオフにする
2. `xcode-select --install`（ダイアログが出るので「インストール」を押す）
3. Claude Code を入れる: `curl -fsSL https://claude.ai/install.sh | bash`
4. dotfiles を HTTPS で clone する: `git clone https://github.com/Rioh1118/dotfiles.git ~/dotfiles`

---

## プロンプト

```text
新しい MacBook (Apple Silicon) の開発環境をセットアップしてほしい。移行アシスタントは使っていないクリーンな状態。
設定はすべて ~/dotfiles（GitHub: Rioh1118/dotfiles、public）にある。まず ~/dotfiles/README.md を読んで構成と運用規則を把握してから始めて。

## 進め方のルール
- sudo やパスワード入力、ブラウザ認証、パスフレーズ入力が必要なコマンドは、自分で実行せず「! <コマンド>」の形で私に実行を頼むこと。
- Brewfile にないものはインストールしない。必要そうなものがあれば提案だけして、私が OK したら Brewfile に追記してから入れる。
- 秘密情報（秘密鍵、トークン、.env）は dotfiles に入れない。マシン固有の設定は ~/.zshrc.local と ~/.config/git/config.local に書く。
- dotfiles への commit と push は、差分を見せて私が OK してから。
- 各ステップが終わったら、何をしたかを 1〜2 行で報告してから次へ進む。

## 手順

### 1. bootstrap
- ~/dotfiles/bootstrap.sh の中身を読んで、何をするか要約して見せる。
- Homebrew のインストールで sudo が必要なので、私に「! ~/dotfiles/bootstrap.sh」を実行してもらう。
- 終わったら結果を確認する: `which -a brew` が /opt/homebrew/bin/brew の 1 行だけ / `brew bundle check --file ~/dotfiles/Brewfile` / `mise ls` / `rustc --version` / ~/.zshrc 等が ~/dotfiles へのシンボリックリンクになっていること。
- 失敗した箇所があれば原因を調べて直す。bootstrap.sh 自体に問題があれば修正案を出す。

### 2. GitHub 認証
- 私に「! gh auth login -h github.com -p ssh -s admin:public_key,admin:ssh_signing_key -w」を実行してもらう（ブラウザ認証）。
- `gh auth status` で確認する。

### 3. SSH 鍵
- ~/.ssh/id_ed25519 がまだ無いことを確認する。
- 私に「! ssh-keygen -t ed25519 -C "90512887+Rioh1118@users.noreply.github.com" -f ~/.ssh/id_ed25519」を実行してもらう（パスフレーズは私が入力する）。
- ~/.ssh/config を作る（パーミッション 600、~/.ssh は 700）:
    Host github.com
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519
- 私に「! ssh-add --apple-use-keychain ~/.ssh/id_ed25519」を実行してもらう（パスフレーズを Keychain に保存）。
- 公開鍵を GitHub に登録する。認証用と署名用の両方:
    gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication --title "M6 MacBook"
    gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title "M6 MacBook signing"
- `ssh -T git@github.com` で認証できることを確認する（初回の known_hosts 追加は GitHub の公式フィンガープリントと照合してから）。

### 4. Git の設定
- user.name / user.email は ~/.config/git/config（dotfiles 管理）に入っている。`git config --get user.name` と `git config --get user.email` で Rioh / 90512887+Rioh1118@users.noreply.github.com になっていることを確認する。
- コミット署名を SSH 鍵で設定する。~/.config/git/config.local（Git 管理外）に書く:
    [user]
        signingkey = ~/.ssh/id_ed25519.pub
    [gpg]
        format = ssh
    [gpg "ssh"]
        allowedSignersFile = ~/.config/git/allowed_signers
    [commit]
        gpgsign = true
    [tag]
        gpgsign = true
- ~/.config/git/allowed_signers に「<email> namespaces="git" <公開鍵>」の 1 行を書く。
- 一時ディレクトリで空コミットを作り、`git log --show-signature -1` で署名が Good になることを確認して、一時ディレクトリは消す。
- ~/dotfiles の remote を SSH に切り替える: git@github.com:Rioh1118/dotfiles.git

### 5. 動作確認
- zsh: `time zsh -i -c exit` を 3 回測る。100ms を超えたら `zmodload zsh/zprof` で原因を調べて報告する（直す前に相談）。
- tmux: ~/.local/share/tmux/plugins に tpm / resurrect / continuum / vim-tmux-navigator / themepack が入っていること。
- WezTerm: 起動すると tmux の main セッションに入る設定になっていることを wezterm.lua で確認する（GUI の確認は私がやる）。
- Neovim: `nvim --headless "+Lazy! restore" +qa` でプラグインを lazy-lock.json の版で入れ、`nvim --headless "+checkhealth" +qa` の結果から ERROR だけ抜き出して報告する。Mason の LSP は初回起動時に入るので、私が nvim を開くよう案内する。
- yazi: `yazi --version`。flavors が ~/.config/yazi/flavors にあること。
- bat: `bat --list-themes | grep tokyonight`。
- Docker: Docker Desktop は初回だけ GUI での起動と許可が必要なので、私に起動を頼む。起動したら `docker run --rm hello-world`。
- launchd: `launchctl print gui/$(id -u)/com.local.sweep-downloads` で読み込まれていること。Downloads へのアクセスにはフルディスクアクセスが必要なので、システム設定での手順を私に案内する。

### 6. 最後に
- 次のチェックリストを、結果（OK / NG / 私の手作業待ち）付きの表にして出す:
  Homebrew 1 系統 / Brewfile 全部入った / stow のリンク / mise と rustup / gh 認証 / SSH 認証 / コミット署名 / zsh 起動時間 / tmux プラグイン / nvim / Docker / launchd / フルディスクアクセス
- このあと手でやること（ブラウザ・Raycast の Import・iCloud Drive の secrets.dmg から .env を戻す など）を箇条書きで出す。
```
