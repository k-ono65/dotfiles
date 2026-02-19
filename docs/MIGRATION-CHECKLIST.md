# Mac 移行チェックリスト

## 移行前 (旧Mac)

- [ ] `scripts/export-current.sh` を実行してデータ収集
- [ ] Brewfile の内容を確認・整理
- [ ] dotfiles リポジトリをコミット・プッシュ
- [ ] 以下のファイルを AirDrop/USB でコピー:
  - [ ] `~/.ssh/` (config + 各種キーディレクトリ)
  - [ ] `~/.aws/` (config, credentials, sso/)
  - [ ] `~/.zsh/.zsh_secret` (APIトークン等)

## 移行後 (新Mac)

### 1. 基本セットアップ

- [ ] Xcode Command Line Tools: `xcode-select --install`
- [ ] dotfiles クローン: `git clone git@github.com:k-ono65/dotfiles.git ~/dotfiles`
- [ ] SSH鍵をコピーして `chmod 600` で権限設定
- [ ] `~/dotfiles/setup.sh` を実行

### 2. セットアップスクリプト実行後の確認

- [ ] Homebrew パッケージがインストールされた
- [ ] zsh シンボリックリンクが正しい (`ls -la ~/.zshenv ~/.zsh/`)
- [ ] vim シンボリックリンクが正しい (`ls -la ~/.vimrc ~/.vim`)
- [ ] `~/.config/` のシンボリックリンクが正しい
- [ ] gitconfig が機能する (`git config --list`)
- [ ] Claude Code 設定がリンクされた
- [ ] mise ツールがインストールされた
- [ ] Rust / cargo パッケージがインストールされた
- [ ] HackGen フォントがインストールされた

### 3. 手動設定

- [ ] `~/.gitconfig.local` の作成 (OAuthトークン、pr-releaseトークン)
- [ ] `~/.zsh/.zsh_secret` のコピー
- [ ] `~/.aws/` のコピー
- [ ] Neovim 設定: `ghq get taktalf/dotfiles` → `ln -snf $(ghq root)/github.com/taktalf/dotfiles/nvim ~/.config/nvim`
- [ ] Docker Desktop インストール
- [ ] Karabiner-Elements 設定確認
- [ ] Kiro CLI インストール

### 4. 動作確認

- [ ] 新ターミナルを開いて pure prompt が表示される
- [ ] sheldon プラグインが動作する
- [ ] mise でツール切り替えが正常
- [ ] `ghq` + `fzf` のリポジトリ移動 (`Ctrl+]`) が機能する
- [ ] alacritty の透明度切り替えが機能する
- [ ] git delta が動作する
- [ ] Docker が正常起動する
- [ ] `brew bundle check --file=~/dotfiles/Brewfile` が通る
