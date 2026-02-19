# dotfiles

Mac 環境のセットアップと設定ファイル管理リポジトリ。

## クイックスタート

```bash
git clone git@github.com:k-ono65/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## リポジトリ構成

```
dotfiles/
├── setup.sh                  # メインセットアップスクリプト
├── Brewfile                  # Homebrew パッケージ一覧
├── .zshenv                   # ZDOTDIR 設定 (root)
├── .zsh/                     # zsh 設定
│   ├── .zshrc
│   ├── .zshenv
│   ├── .zprofile
│   └── rc/                   # 分割設定 (alias, options, plugins)
├── .vimrc                    # Vim 設定
├── .vim/                     # Vim プラグイン等
├── config/                   # ~/.config/ 配下の設定
│   ├── alacritty/            # ターミナル
│   ├── sheldon/              # zsh プラグインマネージャ
│   ├── karabiner/            # キーマッピング
│   ├── mise/                 # ランタイム管理
│   ├── zellij/               # ターミナルマルチプレクサ
│   └── gitui/                # Git TUI
├── git/                      # Git 設定
│   └── .gitconfig.base       # トークン除外版 gitconfig
├── claude/                   # Claude Code 設定
│   ├── CLAUDE.md
│   ├── terraform-rules.md
│   └── settings.json
├── scripts/                  # ユーティリティスクリプト
│   └── export-current.sh     # 現環境データ収集
└── docs/
    └── MIGRATION-CHECKLIST.md
```

## セットアップスクリプト

`setup.sh` は冪等に設計されており、何度実行しても安全です。

### 全体実行

```bash
./setup.sh
```

### 個別関数の実行

```bash
./setup.sh install_homebrew        # Homebrew インストール
./setup.sh install_brewfile        # Brewfile からパッケージインストール
./setup.sh setup_symlinks_zsh      # zsh シンボリックリンク
./setup.sh setup_symlinks_vim      # vim シンボリックリンク
./setup.sh setup_symlinks_config   # ~/.config/ シンボリックリンク
./setup.sh setup_gitconfig         # gitconfig セットアップ
./setup.sh setup_claude            # Claude Code 設定
./setup.sh install_mise_tools      # mise ツールインストール
./setup.sh install_rust            # Rust + cargo パッケージ
./setup.sh install_fonts           # HackGen35 Console NF フォント
./setup.sh install_google_cloud_sdk # Google Cloud SDK
./setup.sh setup_ghq               # ghq リポジトリガイド表示
./setup.sh print_manual_steps      # 手動作業一覧
```

## 手動で行う作業

セットアップスクリプトでカバーできない項目:

- `~/.ssh/` のコピー
- `~/.aws/` のコピー
- `~/.zsh/.zsh_secret` の作成
- `~/.gitconfig.local` の作成 (OAuth / pr-release トークン)
- Neovim 設定 (`ghq get taktalf/dotfiles`)
- Docker Desktop / Karabiner-Elements / Kiro CLI のインストール

詳細は [docs/MIGRATION-CHECKLIST.md](docs/MIGRATION-CHECKLIST.md) を参照。

## 現環境データの収集

移行前に現在の環境情報をエクスポート:

```bash
./scripts/export-current.sh
```

`exports/` に以下が出力されます (gitignore 対象):
- `ghq-list.txt` - ghq リポジトリ一覧
- `mise-list.txt` - mise ツール一覧
- `npm-global.txt` - npm グローバルパッケージ
